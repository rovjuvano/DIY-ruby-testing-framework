module MySpec
  module DSL
    def describe(description, &block)
      context = ContextDSL.new
      context.instance_eval &block
      context.run_tests
    end
  end

  class ContextDSL
    def initialize
      @givens = []
      @whens = []
      @thens = []
    end

    def Given(name=nil, &block)
      @givens << Given.new(name, block)
    end

    def When(name=nil, &block)
      @whens << When.new(name, block)
    end

    def Then(&block)
      @thens << Then.new(block)
    end

    def run_tests
      @thens.each do |t|
        this = Object.new
        @givens.each { |g| g.apply(this) }
        @whens.each { |w| w.apply(this) }
        puts t.execute(this)
      end
    end
  end

  class Aspect
    def initialize(name, block)
      @name = name
      @block = block
    end

    def apply(this)
      result = this.instance_eval &@block
      this.instance_variable_set("@#{@name}", result) if @name
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
