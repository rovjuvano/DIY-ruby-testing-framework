module DSL
  def describe(&block)
    context = Context.new(nil)
    ContextDSL.new(context).instance_eval &block
    context.run
  end
end

class ContextDSL
  def initialize(context)
    @context = context
  end

  def context(&block)
    @context = @context.add_context
    instance_eval &block
    @context = @context.parent
  end

  def Given(&block)
    @context.add_given(block)
  end

  def Then(&block)
    @context.add_then(block)
  end
end

class Context
  attr_reader :parent
  def initialize(parent)
    @parent = parent
    @contexts = []
    @givens = []
    @thens = []
  end

  def add_context
    @contexts << Context.new(self)
    @contexts.last
  end

  def add_given(block)
    @givens << Given.new(block)
  end

  def add_then(block)
    @thens << Then.new(block)
  end

  def apply_givens
    @parent.apply_givens if @parent
    @givens.each {|g| g.run}
  end

  def run
    @thens.each do |t|
      puts t.run(self) ? 'pass' : 'fail'
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

  def run(context)
    context.apply_givens
    begin
      result = @block.call
    rescue
      result = false
    end
    result
  end
end

extend DSL
