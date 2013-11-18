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
    @and_parent = :Given
    @context.add_given(name, block)
  end

  def When(name=nil, &block)
    @and_parent = :When
    @context.add_when(name, block)
  end

  def Then(&block)
    @and_parent = :ThenAnd
    @then = @context.add_then(block)
  end

  def And(*args, &block)
    if @and_parent == :ThenAnd
      @then.add_check(*args, &block)
    else
      send(@and_parent, *args, &block)
    end
  end
end

class Context
  attr_reader :parent
  def initialize(parent)
    @parent = parent
    @contexts = []
    @givens = []
    @whens = []
    @exceptions = []
    @thens = []
  end

  def add_context
    @contexts << Context.new(self)
    @contexts.last
  end

  def add_given(name, block)
    @givens << Given.new(name, block)
  end

  def add_when(name, block)
    @whens << When.new(name, block)
  end

  def add_then(block)
    @thens << Then.new(block)
    @thens.last
  end

  def apply_givens(this)
    @parent.apply_givens(this) if @parent
    @givens.each {|g| g.run(this)}
  end

  def apply_whens(this)
    @parent.apply_whens(this) if @parent
    @whens.each do |w|
      begin
        w.run(this)
      rescue Exception => e
        @exceptions << e
      end
    end
  end

  def has_failed(re)
    @exceptions.find(re) || (@parent && @parent.has_failed(re))
  end

  def run
    @thens.each do |t|
      puts t.run(self) ? 'pass' : 'fail'
    end
    @contexts.each {|c| c.run}
  end
end

class Aspect
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

class Given < Aspect; end
class When < Aspect; end

class Then
  def initialize(block)
    @checks = [Check.new(block)]
  end

  def add_check(&block)
    @checks << Check.new(block)
  end

  def run(context)
    this = Object.new
    this.define_singleton_method(:has_failed) do |*args|
      context.has_failed(*args)
    end
    context.apply_givens(this)
    context.apply_whens(this)
    @checks.all? do |c|
      c.run(this)
    end
  end
end

class Check
  def initialize(block)
    @block = block
  end

  def run(this)
    begin
      result = this.instance_eval &@block
    rescue
      result = false
    end
    result
  end
end

extend DSL
