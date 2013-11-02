module DSL
  def Then(&block)
  begin
    result = block.call
    puts result ? 'pass' : 'fail'
  rescue Exception => e
    puts e
  end
  end
end
extend DSL
