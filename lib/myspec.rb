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

  def Given(name=nil, &block)
    @context.add_given(name, block)
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

  def add_given(name, block)
    @givens << Given.new(name, block)
  end

  def add_then(block)
    @thens << Then.new(block)
  end

  def apply_givens(this)
    @parent.apply_givens(this) if @parent
    @givens.each {|g| g.run(this)}
  end

  def run
    @thens.each do |t|
      puts t.run(self) ? 'pass' : 'fail'
    end
    @contexts.each {|c| c.run}
  end
end

class Given
  def initialize(name, block)
    @name = name
    @block = block
  end

  def run(this)
    if @name
      this.define_singleton_method(@name, &@block)
    else
      this.instance_eval &@block
    end
  end
end

class Then
  def initialize(block)
    @block = block
  end

  def run(context)
    this = Object.new
    context.apply_givens(this)
    begin
      result = this.instance_eval &@block
    rescue
      result = false
    end
    result
  end
end

extend DSL
