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
      @thens = []
    end

    def Given(name=nil, &block)
      @givens << Given.new(name, block)
    end

    def Then(&block)
      @thens << Then.new(block)
    end

    def run_tests
      @thens.each do |t|
        @givens.each { |g| g.apply }
        puts t.execute
      end
    end
  end

  class Given
    def initialize(name, block)
      @name = name
      @block = block
    end

    def apply
      @block.call
    end
  end

  class Then
    def initialize(block)
      @block = block
    end

    def execute
    begin
      result = @block.call
    rescue Exception => e
      result = false
    end
    result
    end
  end
end
extend MySpec::DSL
