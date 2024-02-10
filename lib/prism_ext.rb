# frozen_string_literal: true

require_relative "prism_ext/version"
require 'prism'

module PrismExt
  class Error < StandardError; end
  # Your code goes here...
end

module Prism
  class Node
    def source
      location.instance_variable_get(:@source).source
    end

    def keys
      if is_a?(HashNode)
        elements.map(&:key)
      else
        raise MethodNotSupported, "keys is not supported for #{self}"
      end
    end

    def values
      if is_a?(HashNode)
        elements.map(&:value)
      else
        raise MethodNotSupported, "values is not supported for #{self}"
      end
    end

    def hash_pair(key)
      if is_a?(HashNode)
        elements.find { |element_node| element_node.key.to_value == key }
      else
        raise MethodNotSupported, "hash_pair is not supported for #{self}"
      end
    end

    def hash_value(key)
      if is_a?(HashNode)
        elements.find { |element_node| element_node.key.to_value == key }&.value
      else
        raise MethodNotSupported, "hash_value is not supported for #{self}"
      end
    end

    # Respond key value and source for hash node
    def method_missing(method_name, *args, &block)
      return super unless is_a?(HashNode)

      if method_name.to_s.end_with?('_pair')
        key = method_name.to_s[0..-6]
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
      return super unless is_a?(HashNode)

      if method_name.to_s.end_with?('_pair')
        key = method_name[0..-6]
        return !!elements.find { |element| element.key.to_value.to_s == key }
      elsif method_name.to_s.end_with?('_value')
        key = method_name[0..-7]
        return !!elements.find { |element| element.key.to_value.to_s == key }
      elsif method_name.to_s.end_with?('_source')
        key = method_name.to_s[0..-8]
        return !!elements.find { |element| element.key.to_value.to_s == key }
      end

      super
    end
  end
end
