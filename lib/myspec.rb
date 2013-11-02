module MySpec
  module DSL
    def describe(description, &block)
      ContextDSL.new.instance_eval &block
    end
  end

  class ContextDSL
    def initialize
      @givens = []
    end

    def Given(&block)
      @givens << block
    end

    def Then(&block)
      @givens.each { |g| g.call }
      puts Then.new(block).execute
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
