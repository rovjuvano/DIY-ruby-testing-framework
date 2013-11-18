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

  def Then
    @givens.each {|g| g.run}
    begin
      result = yield
    rescue
      result = false
    end
    puts result ? 'pass' : 'fail'
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

extend DSL
