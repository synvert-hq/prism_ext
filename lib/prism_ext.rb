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

    def to_source
      # node.slice doesn't work for InterpolatedStringNode
      if respond_to?(:opening_loc) && respond_to?(:closing_loc) && opening_loc && closing_loc
        range = [location.start_offset, opening_loc.start_offset].min...[closing_loc.end_offset, location.end_offset].max
      else
        range = location.start_offset...location.end_offset
      end
      location.send(:source).source[range]
    end
  end
end
