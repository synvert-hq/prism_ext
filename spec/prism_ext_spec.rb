# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PrismExt do
  def parse(code)
    Prism.parse(code).value.statements.body.first
  end

  let(:source) { <<~EOS }
    class Synvert
      def initialize; end
      def foo; end
      def bar; end
    end
  EOS

  let(:node) { parse(source) }

  it 'gets source' do
    expect(node.source).to eq source
  end
end
