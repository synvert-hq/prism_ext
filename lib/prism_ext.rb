# frozen_string_literal: true

require_relative "prism_ext/version"

require 'prism'

module PrismExt
  class Error < StandardError; end
  # Your code goes here...
end

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

    def keys
      if respond_to_elements?
        elements.map(&:key)
      else
        raise MethodNotSupported, "keys is not supported for #{self}"
      end
    end

    def values
      if respond_to_elements?
        elements.map(&:value)
      else
        raise MethodNotSupported, "values is not supported for #{self}"
      end
    end

    def hash_element(key)
      if respond_to_elements?
        elements.find { |element_node| element_node.key.to_value == key }
      else
        raise MethodNotSupported, "hash_pair is not supported for #{self}"
      end
    end

    def hash_value(key)
      if respond_to_elements?
        elements.find { |element_node| element_node.key.to_value == key }&.value
      else
        raise MethodNotSupported, "hash_value is not supported for #{self}"
      end
    end

    def to_value
      case self
      when SymbolNode
        value.to_sym
      when StringNode
        content
      when FloatNode
        value
      when IntegerNode
        value
      when TrueNode
        true
      when FalseNode
        false
      when NilNode
        nil
      when ArrayNode
        elements.map { |element| element.to_value }
      else
        self
      end
    end

    alias :to_source :slice

    # Respond key value and source for hash node
    def method_missing(method_name, *args, &block)
      return super unless respond_to_elements?

      if method_name.to_s.end_with?('_element')
        key = method_name.to_s[0..-9]
        return elements.find { |element| element.key.to_value.to_s == key }
      elsif method_name.to_s.end_with?('_value')
        key = method_name.to_s[0..-7]
        return elements.find { |element| element.key.to_value.to_s == key }&.value
      elsif method_name.to_s.end_with?('_source')
        key = method_name.to_s[0..-8]
        return elements.find { |element| element.key.to_value.to_s == key }&.value&.to_source || ''
      end

      super
    end

    def respond_to_missing?(method_name, *args)
      return super unless respond_to_elements?

      if method_name.to_s.end_with?('_element')
        key = method_name.to_s[0..-9]
        return !!elements.find { |element| element.key.to_value.to_s == key }
      elsif method_name.to_s.end_with?('_value')
        key = method_name.to_s[0..-7]
        return !!elements.find { |element| element.key.to_value.to_s == key }
      elsif method_name.to_s.end_with?('_source')
        key = method_name.to_s[0..-8]
        return !!elements.find { |element| element.key.to_value.to_s == key }
      end

      super
    end

    private

    def respond_to_elements?
      is_a?(HashNode) || is_a?(KeywordHashNode)
    end
  end
end
