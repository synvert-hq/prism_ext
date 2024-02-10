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
  end
end
