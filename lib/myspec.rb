module MySpec
  module DSL
    def Then(&block)
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
