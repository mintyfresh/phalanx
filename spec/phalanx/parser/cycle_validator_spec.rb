# typed: false
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Phalanx::Parser::CycleValidator do
  include ParserHelpers

  subject(:validator) { described_class.new }

  describe '#validate' do
    context 'when there are no cycles' do
      let(:permission_groups) do
        [
          build_permission_group(
            name: 'Users',
            permissions: [
              build_permission(id: 'users.read'),
              build_permission(id: 'users.write', implies: ['users.read']),
              build_permission(id: 'users.admin', implies: ['users.write']),
            ]
          ),
        ]
      end

      it 'does not raise an error' do
        expect { validator.validate(permission_groups) }.not_to raise_error
      end
    end

    context 'when there are no implications' do
      let(:permission_groups) do
        [
          build_permission_group(
            name: 'Users',
            permissions: [
              build_permission(id: 'users.read'),
              build_permission(id: 'users.write'),
              build_permission(id: 'users.delete'),
            ]
          ),
        ]
      end

      it 'does not raise an error' do
        expect { validator.validate(permission_groups) }.not_to raise_error
      end
    end

    context 'when there is a self-referencing cycle' do
      let(:permission_groups) do
        [
          build_permission_group(
            name: 'Users',
            permissions: [
              build_permission(id: 'users.read', implies: ['users.read']),
            ]
          ),
        ]
      end

      it 'raises a CycleError' do
        expect { validator.validate(permission_groups) }.to raise_error(Phalanx::Parser::CycleValidator::CycleError)
      end

      it 'includes the cycle in the error', :aggregate_failures do
        expect { validator.validate(permission_groups) }.to raise_error do |error|
          expect(error.cycles).to contain_exactly(['users.read', 'users.read'])
        end
      end
    end

    context 'when there is a simple two-node cycle' do
      let(:permission_groups) do
        [
          build_permission_group(
            name: 'Users',
            permissions: [
              build_permission(id: 'users.read', implies: ['users.write']),
              build_permission(id: 'users.write', implies: ['users.read']),
            ]
          ),
        ]
      end

      it 'raises a CycleError' do
        expect { validator.validate(permission_groups) }.to raise_error(Phalanx::Parser::CycleValidator::CycleError)
      end

      it 'includes the cycle in the error', :aggregate_failures do
        expect { validator.validate(permission_groups) }.to raise_error do |error|
          expect(error.cycles.size).to eq(1)
          expect(error.cycles.first).to include('users.read', 'users.write')
        end
      end
    end

    context 'when there is a longer cycle' do
      let(:permission_groups) do
        [
          build_permission_group(
            name: 'Users',
            permissions: [
              build_permission(id: 'a', implies: ['b']),
              build_permission(id: 'b', implies: ['c']),
              build_permission(id: 'c', implies: ['a']),
            ]
          ),
        ]
      end

      it 'raises a CycleError' do
        expect { validator.validate(permission_groups) }.to raise_error(Phalanx::Parser::CycleValidator::CycleError)
      end

      it 'includes the complete cycle path', :aggregate_failures do
        expect { validator.validate(permission_groups) }.to raise_error do |error|
          expect(error.cycles.size).to eq(1)
          cycle = error.cycles.first
          expect(cycle).to eq(%w[a b c a])
        end
      end
    end

    context 'when there are multiple independent cycles' do
      let(:permission_groups) do
        [
          build_permission_group(
            name: 'Group1',
            permissions: [
              build_permission(id: 'a', implies: ['b']),
              build_permission(id: 'b', implies: ['a']),
            ]
          ),
          build_permission_group(
            name: 'Group2',
            permissions: [
              build_permission(id: 'x', implies: ['y']),
              build_permission(id: 'y', implies: ['x']),
            ]
          ),
        ]
      end

      it 'raises a CycleError' do
        expect { validator.validate(permission_groups) }.to raise_error(Phalanx::Parser::CycleValidator::CycleError)
      end

      it 'includes all cycles in the error', :aggregate_failures do
        expect { validator.validate(permission_groups) }.to raise_error do |error|
          expect(error.cycles.size).to eq(2)
        end
      end
    end

    context 'when there are multiple cycles sharing nodes' do
      let(:permission_groups) do
        [
          build_permission_group(
            name: 'Complex',
            permissions: [
              build_permission(id: 'a', implies: ['b']),
              build_permission(id: 'b', implies: %w[c d]),
              build_permission(id: 'c', implies: ['a']),
              build_permission(id: 'd', implies: ['b']),
            ]
          ),
        ]
      end

      it 'raises a CycleError' do
        expect { validator.validate(permission_groups) }.to raise_error(Phalanx::Parser::CycleValidator::CycleError)
      end

      it 'detects multiple cycles', :aggregate_failures do
        expect { validator.validate(permission_groups) }.to raise_error do |error|
          expect(error.cycles.size).to eq(2)
        end
      end
    end

    context 'when cycles span across permission groups' do
      let(:permission_groups) do
        [
          build_permission_group(
            name: 'Users',
            permissions: [
              build_permission(id: 'users.admin', implies: ['posts.admin']),
            ]
          ),
          build_permission_group(
            name: 'Posts',
            permissions: [
              build_permission(id: 'posts.admin', implies: ['users.admin']),
            ]
          ),
        ]
      end

      it 'raises a CycleError' do
        expect { validator.validate(permission_groups) }.to raise_error(Phalanx::Parser::CycleValidator::CycleError)
      end

      it 'detects the cross-group cycle', :aggregate_failures do
        expect { validator.validate(permission_groups) }.to raise_error do |error|
          expect(error.cycles.size).to eq(1)
          expect(error.cycles.first).to include('users.admin', 'posts.admin')
        end
      end
    end
  end

  describe Phalanx::Parser::CycleValidator::CycleError do
    subject(:error) { described_class.new(cycles) }

    let(:cycles) { [%w[a b c a], %w[x y x]] }

    describe '#cycles' do
      it 'returns the cycles' do
        expect(error.cycles).to eq(cycles)
      end
    end

    describe '#message' do
      it 'includes a header' do
        expect(error.message).to include('Permission implication cycles detected')
      end

      it 'includes each cycle with arrows', :aggregate_failures do
        expect(error.message).to include('a -> b -> c -> a')
        expect(error.message).to include('x -> y -> x')
      end

      it 'numbers each cycle', :aggregate_failures do
        expect(error.message).to include('1.')
        expect(error.message).to include('2.')
      end
    end
  end
end
