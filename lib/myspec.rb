module DSL
  def Then
    yield
  end
end
extend DSL
