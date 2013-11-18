module DSL
  def describe(&block)
    context = ContextDSL.new
    context.instance_eval &block
    context.run
  end
end

class ContextDSL
  def initialize
    @givens = []
    @thens = []
  end

  def Given(&block)
    @givens << Given.new(block)
  end

  def Then(&block)
    @thens << Then.new(block)
  end

  def run
    @thens.each do |t|
      puts t.run(@givens) ? 'pass' : 'fail'
    end
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
