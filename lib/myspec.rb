module DSL
  def describe(&block)
    ContextDSL.new.instance_eval &block
  end
end

class ContextDSL
  def Given
    yield
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

extend DSL
