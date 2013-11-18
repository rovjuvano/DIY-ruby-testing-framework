module DSL
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
