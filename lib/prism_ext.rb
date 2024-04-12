# frozen_string_literal: true

require_relative "prism_ext/version"

require 'prism'

module PrismExt
  class Error < StandardError; end
  # Your code goes here...
end

module Prism
  module HashNodeExt
    def keys
      elements.select { |element| element.type == :assoc_node }.map(&:key)
    end

    def values
      elements.select { |element| element.type == :assoc_node }.map(&:value)
    end

    def hash_element(key)
      elements.find { |element| element.type == :assoc_node && element.key.to_value == key }
    end

    def hash_value(key)
      elements.find { |element| element.type == :assoc_node && element.key.to_value == key }&.value
    end

    # Respond key value and source for hash node
    def method_missing(method_name, *args, &block)
      if method_name.to_s.end_with?('_element')
        key = method_name.to_s[0..-9]
        return elements.find { |element| element.type == :assoc_node && element.key.to_value.to_s == key }
      elsif method_name.to_s.end_with?('_value')
        key = method_name.to_s[0..-7]
        return elements.find { |element| element.type == :assoc_node && element.key.to_value.to_s == key }&.value
      elsif method_name.to_s.end_with?('_source')
        key = method_name.to_s[0..-8]
        return elements.find { |element| element.type == :assoc_node && element.key.to_value.to_s == key }&.value&.to_source || ''
      end

      super
    end

    def respond_to_missing?(method_name, *args)
      if method_name.to_s.end_with?('_element')
        key = method_name.to_s[0..-9]
        return !!elements.find { |element| element.type == :assoc_node && element.key.to_value.to_s == key }
      elsif method_name.to_s.end_with?('_value')
        key = method_name.to_s[0..-7]
        return !!elements.find { |element| element.type == :assoc_node && element.key.to_value.to_s == key }
      elsif method_name.to_s.end_with?('_source')
        key = method_name.to_s[0..-8]
        return !!elements.find { |element| element.type == :assoc_node && element.key.to_value.to_s == key }
      end

      super
    end
  end

  class HashNode
    include HashNodeExt
  end

  class KeywordHashNode
    include HashNodeExt
  end

  class Node
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
  end
end
