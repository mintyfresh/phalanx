# typed: strict
# frozen_string_literal: true

module Phalanx
  class Parser
    # Validates that permissions do not form a cycle by implication.
    class CycleValidator
      extend T::Sig

      class CycleError < Phalanx::Error
        extend T::Sig

        sig { returns(T::Array[T::Array[String]]) }
        attr_reader :cycles

        sig { params(cycles: T::Array[T::Array[String]]).void }
        def initialize(cycles)
          super(build_message(cycles))

          @cycles = cycles
        end

      private

        sig { params(cycles: T::Array[T::Array[String]]).returns(String) }
        def build_message(cycles)
          cycle_descriptions = cycles.map.with_index(1) do |cycle, index|
            "  #{index}. #{cycle.join(' -> ')}"
          end

          [
            'Permission implication cycles detected:',
            *cycle_descriptions,
          ].join("\n")
        end
      end

      sig { params(permission_groups: T::Array[Parser::PermissionGroup]).void }
      def validate(permission_groups)
        # Build a graph: permission_id -> array of implied permission_ids
        graph = T.let({}, T::Hash[String, T::Array[String]])

        permission_groups.each do |permission_group|
          permission_group.permissions.each do |permission|
            graph[permission.id] = permission.implies
          end
        end

        cycles = find_all_cycles(graph)

        raise CycleError, cycles if cycles.any?
      end

    private

      sig { params(graph: T::Hash[String, T::Array[String]]).returns(T::Array[T::Array[String]]) }
      def find_all_cycles(graph)
        # Track global visited state and current path
        visited = T.let(Set.new, T::Set[String])
        path = T.let([], T::Array[String])
        path_set = T.let(Set.new, T::Set[String])
        cycles = T.let([], T::Array[T::Array[String]])

        graph.each_key do |node|
          next if visited.include?(node)

          dfs(node, graph, visited, path, path_set, cycles)
        end

        # Normalize cycles to remove duplicates (same cycle starting from different points)
        normalize_cycles(cycles)
      end

      sig do
        params(
          node: String,
          graph: T::Hash[String, T::Array[String]],
          visited: T::Set[String],
          path: T::Array[String],
          path_set: T::Set[String],
          cycles: T::Array[T::Array[String]]
        ).void
      end
      def dfs(node, graph, visited, path, path_set, cycles) # rubocop:disable Metrics/ParameterLists
        visited.add(node)
        path.push(node)
        path_set.add(node)

        neighbors = graph.fetch(node, [])
        neighbors.each do |neighbor|
          if path_set.include?(neighbor)
            # Found a cycle - extract it from the path
            cycle_start_index = T.must(path.index(neighbor))
            cycle = [*path[cycle_start_index..], neighbor]
            cycles << cycle
          elsif visited.exclude?(neighbor)
            dfs(neighbor, graph, visited, path, path_set, cycles)
          end
        end

        path.pop
        path_set.delete(node)
      end

      sig { params(cycles: T::Array[T::Array[String]]).returns(T::Array[T::Array[String]]) }
      def normalize_cycles(cycles)
        seen = T.let(Set.new, T::Set[String])

        cycles.select do |cycle|
          # Remove the duplicate last element for normalization
          cycle_nodes = cycle[0...-1] || []

          # Rotate to start from the smallest element for consistent comparison
          min_index = cycle_nodes.each_with_index.min_by { |node, _| node }&.last || 0
          rotated = cycle_nodes.rotate(min_index)
          normalized = rotated.join(' -> ')

          if seen.include?(normalized)
            false
          else
            seen.add(normalized)
            true
          end
        end
      end
    end
  end
end
