module DSL
  def describe(&block)
    ContextDSL.new.instance_eval &block
  end
end

class ContextDSL
  def Given(&block)
    Given.new(block).run
  end

  def Then
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
