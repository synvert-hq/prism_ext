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
  end
end
