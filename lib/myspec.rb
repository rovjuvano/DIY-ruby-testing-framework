module MySpec
  module DSL
    def Then(&block)
      Then.new(block).execute
    end
  end

  class Then
    def initialize(block)
      @block = block
    end

    def execute
    begin
      result = @block.call
      puts result ? 'pass' : 'fail'
    rescue Exception => e
      puts e
    end
    end
  end
end
extend MySpec::DSL
