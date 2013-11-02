module DSL
  def Then(&block)
    block.call
  end
end
extend DSL
