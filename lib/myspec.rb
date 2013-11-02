module MySpec
  module DSL
    def describe(description, &block)
      context = Context.new(description)
      ContextDSL.new(context).instance_eval &block
      context.run_tests
    end
  end

  class ContextDSL
    def initialize(context)
      @context = context
    end

    def context(description, &block)
      @context = @context.add_context(description)
      instance_eval &block
      @context = @context.parent
    end

    def Given(name=nil, &block)
      @context.add_given(name, block, false)
    end

    def Given!(name, &block)
      @context.add_given(name, block, true)
    end

    def When(name=nil, &block)
      @context.add_when(name, block)
    end

    def Then(&block)
      @context.add_then(block)
    end
  end

  class Context
    attr_reader :parent
    def initialize(description, parent=nil)
      @description = description
      @parent = parent
      @contexts = []
      @givens = []
      @whens = []
      @thens = []
    end

    def add_context(description)
      @contexts << Context.new(description, self)
      @contexts.last
    end

    def add_given(name, block, eager)
      @givens << Given.new(name, block, eager)
    end

    def add_when(name, block)
      @whens << When.new(name, block, true)
    end

    def add_then(block)
      @thens << Then.new(block)
    end

    def apply_givens(this)
      parent.apply_givens(this) if parent
      @givens.each { |g| g.apply(this) }
    end

    def apply_whens(this)
      parent.apply_whens(this) if parent
      @whens.each { |w| w.apply(this) }
    end

    def run_tests
      @thens.each do |t|
        this = Object.new
        apply_givens(this)
        apply_whens(this)
        puts t.execute(this)
      end
      @contexts.each { |c| c.run_tests }
    end
  end

  class Aspect
    def initialize(name, block, eager)
      @name = name
      @block = block
      @eager = eager
    end

    def apply(this)
      if @name
        block = @block
        result = nil
        called = false
        this.define_singleton_method(@name) do
          return result if called
          called = true
          result = instance_eval &block
        end
        this.send(@name) if @eager
      else
        this.instance_eval &@block
      end
    end
  end

  class Given < Aspect; end
  class When < Aspect; end

  class Then
    def initialize(block)
      @block = block
    end

    def execute(this)
    begin
      result = this.instance_eval &@block
    rescue Exception => e
      result = false
    end
    !!result
    end
  end
end
extend MySpec::DSL
