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

  describe '#to_value' do
    it 'gets for symbol' do
      node = parse(':foo')
      expect(node.to_value).to eq :foo
    end

    it 'gets for string' do
      node = parse('"foo"')
      expect(node.to_value).to eq 'foo'
    end

    it 'gets for float' do
      node = parse('1.1')
      expect(node.to_value).to eq 1.1
    end

    it 'gets for int' do
      node = parse('1')
      expect(node.to_value).to eq 1
    end

    it 'gets for bool' do
      node = parse('true')
      expect(node.to_value).to eq true
      node = parse('false')
      expect(node.to_value).to eq false
    end

    it 'gets for nil' do
      node = parse('nil')
      expect(node.to_value).to eq nil
    end

    it 'gets for array' do
      node = parse("['str', :str]")
      expect(node.to_value).to eq ['str', :str]
    end

    it 'gets for empty array' do
      node = parse('[]')
      expect(node.to_value).to eq []
    end
  end

  describe '#to_source' do
    it 'gets source' do
      child_node = node.body.body.first
      expect(child_node.to_source).to eq "def initialize; end"
    end

    it 'gets source for call node' do
      node = parse('foo(bar)')
      expect(node.to_source).to eq 'foo(bar)'
    end

    it 'gets source for heredoc' do
      node = parse(<<~EOS)
        <<~HEREDOC
          hello
          world
        HEREDOC
      EOS
      expect(node.to_source).to eq <<~EOS
        <<~HEREDOC
          hello
          world
        HEREDOC
      EOS
    end

    it 'gets source for call with heredoc argument' do
      node = parse(<<~EOS)
        test(<<~HEREDOC)
          hello
          world
        HEREDOC
      EOS
      expect(node.to_source).to eq <<~EOS
        test(<<~HEREDOC)
          hello
          world
        HEREDOC
      EOS
    end

    it 'gets source for block' do
      node = parse(<<~EOS.strip)
        def fooboar(&block)
          foobar(&block)
        end
      EOS
      expect(node.to_source).to eq <<~EOS.strip
        def fooboar(&block)
          foobar(&block)
        end
      EOS
      expect(node.body.body.first.to_source).to eq <<~EOS.strip
        foobar(&block)
      EOS
    end
  end

  describe '#keys' do
    it 'gets for hash node' do
      node = parse("{ **foobar, :foo => :bar, 'foo' => 'bar' }")
      expect(node.keys).to eq [node.elements[1].key, node.elements[2].key]
    end
  end

  describe '#values' do
    it 'gets for hash node' do
      node = parse("{ **foobar, :foo => :bar, 'foo' => 'bar' }")
      expect(node.values).to eq [node.elements[1].value, node.elements[2].value]
    end
  end

  describe 'element of hash node by method_missing' do
    it 'gets for hash node' do
      node = parse('{:foo => :bar}')
      expect(node.foo_element.to_source).to eq ':foo => :bar'

      node = parse('{ foo: :bar }')
      expect(node.foo_element.to_source).to eq 'foo: :bar'

      node = parse("{'foo' => 'bar'}")
      expect(node.foo_element.to_source).to eq "'foo' => 'bar'"

      node = parse("{ foo: 'bar' }")
      expect(node.foo_element.to_source).to eq "foo: 'bar'"

      node = parse("{ **foobar, foo: 'bar' }")
      expect(node.foo_element.to_source).to eq "foo: 'bar'"

      expect(node.bar_element).to be_nil
    end
  end

  describe 'value of hash node by method_missing' do
    it 'gets for hash node' do
      node = parse('{:foo => :bar}')
      expect(node.foo_value.to_source).to eq ':bar'

      node = parse('{ foo: :bar }')
      expect(node.foo_value.to_source).to eq ':bar'

      node = parse("{'foo' => 'bar'}")
      expect(node.foo_value.to_source).to eq "'bar'"

      node = parse("{ foo: 'bar' }")
      expect(node.foo_value.to_source).to eq "'bar'"

      node = parse("{ **foobar, foo: 'bar' }")
      expect(node.foo_value.to_source).to eq "'bar'"

      expect(node.bar_value).to be_nil
    end
  end

  describe 'value source of hash node by method_missing' do
    it 'gets for hash node' do
      node = parse('{:foo => :bar}')
      expect(node.foo_source).to eq ':bar'

      node = parse("{'foo' => 'bar'}")
      expect(node.foo_source).to eq "'bar'"

      node = parse("{ **foobar, 'foo' => 'bar'}")
      expect(node.foo_source).to eq "'bar'"

      expect(node.bar_source).to eq ''
    end
  end
end
