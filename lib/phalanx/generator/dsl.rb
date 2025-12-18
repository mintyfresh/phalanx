# typed: strict
# frozen_string_literal: true

module Phalanx
  class Generator
    class DSL
      extend T::Sig

      SPACES_PER_INDENT = 2

      sig { void }
      def initialize
        @buffer = T.let([], T::Array[String])
        @indent_level = T.let(0, Integer)
      end

      sig { returns(String) }
      def generate
        @buffer.join
      end

      sig { params(text: String).returns(DSL) }
      def comment(text)
        text.lines.each do |line|
          @buffer << indented("# #{line.strip}\n")
        end
        self
      end

      sig { returns(DSL) }
      def newline
        @buffer << "\n"
        self
      end

      sig do
        params(name: String, superclass: T.nilable(String), block: T.nilable(T.proc.params(dsl: DSL).void))
          .returns(DSL)
      end
      def class(name, superclass: nil, &block)
        @buffer << indented("class #{name}")
        @buffer << " < #{superclass}" if superclass
        @buffer << "\n"
        with_indent(&block)
        @buffer << indented('end')
        @buffer << "\n"
        self
      end

      sig { params(names: String).returns(DSL) }
      def include(*names)
        @buffer << indented("include #{names.join(', ')}\n")
        self
      end

      sig { params(block: T.nilable(T.proc.params(dsl: DSL).void)).returns(DSL) }
      def enums(&block)
        @buffer << indented("enums do\n")
        with_indent(&block)
        @buffer << indented("end\n")
        self
      end

      sig { params(name: String, attributes: T::Hash[String, T.untyped]).returns(DSL) }
      def enum(name, attributes)
        @buffer << indented("#{name} = new(\n")
        with_indent do
          attributes.each do |key, value|
            @buffer << indented("#{key.inspect} => #{value.inspect},\n")
          end
        end
        @buffer << indented(")\n")
        self
      end

    private

      sig { params(step: Integer, block: T.nilable(T.proc.params(dsl: DSL).void)).returns(DSL) }
      def with_indent(step = 1, &block) # rubocop:disable Metrics/UnusedMethodArgument
        @indent_level += step
        yield self if block_given?
        self
      ensure
        @indent_level -= step
      end

      sig { params(text: String).returns(String) }
      def indented(text)
        (' ' * (@indent_level * SPACES_PER_INDENT)) + text
      end
    end
  end
end
