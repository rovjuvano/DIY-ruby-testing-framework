module DSL
  def describe(&block)
    context = Context.new
    ContextDSL.new(context).instance_eval &block
    context.run
  end
end

class ContextDSL
  def initialize(context)
    @context = context
  end

  def context(&block)
    parent_context = @context;
    @context = @context.add_context
    instance_eval &block
    @context = parent_context
  end

  def Given(&block)
    @context.add_given(block)
  end

  def Then(&block)
    @context.add_then(block)
  end
end

class Context
  def initialize
    @contexts = []
    @givens = []
    @thens = []
  end

  def add_context
    @contexts << Context.new
    @contexts.last
  end

  def add_given(block)
    @givens << Given.new(block)
  end

  def add_then(block)
    @thens << Then.new(block)
  end

  def run
    @thens.each do |t|
      puts t.run(@givens) ? 'pass' : 'fail'
    end
    @contexts.each {|c| c.run}
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
