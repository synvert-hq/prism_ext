# frozen_string_literal: true

module Prism
  class << self
    alias_method :original_parse, :parse

    def parse(source)
      result = original_parse(source)
      result.value.set_parent_node
      result
    end
  end

  class Node
    attr_accessor :parent_node

    def set_parent_node
      self.compact_child_nodes.each do |child_node|
        if child_node.is_a?(Array)
          child_node.each do |child_child_node|
            child_child_node.parent_node = self
            child_child_node.set_parent_node
          end
        else
          child_node.parent_node = self
          child_node.set_parent_node
        end
      end
    end
  end
end
