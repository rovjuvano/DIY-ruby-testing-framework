module DSL
  def describe(&block)
    ContextDSL.new.instance_eval &block
  end
end

class ContextDSL
  def initialize
    @givens = []
  end

  def Given(&block)
    @givens << Given.new(block)
  end

  def Then(&block)
    puts Then.new(block).run(@givens) ? 'pass' : 'fail'
  end
end

class Given
  def initialize(block)
    @block = block
  end

  def run
    @block.call
  end
end

class Then
  def initialize(block)
    @block = block
  end

  def run(givens)
    givens.each {|g| g.run}
    begin
      result = @block.call
    rescue
      result = false
    end
    result
  end
end

extend DSL
