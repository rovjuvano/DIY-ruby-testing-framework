class Myspec
  def self.run(file)
    myspec = Myspec.new
    myspec.instance_eval(file.read())
    myspec.run_tests
  end

  def initialize
    @context = Context.new('*** TOPLEVEL ***', nil)
  end

  def run_tests
    @context.run_tests
  end

  def describe(description, &block)
    @context = @context.add_context(description)
    block.call
    @context = @context.parent
  end
  alias_method :context, :describe

  def Given(name=nil, &block)
    @context.add_given(name, block)
  end

  def When(name=nil, &block)
    @context.add_when(name, block)
  end

  def Invariant(&block)
    @context.add_invariant(block)
  end

  def Then(&block)
    @context.add_then(block)
  end

  def onDone(&block)
    @context.add_ondone(block)
  end

  class Context
    attr_reader :parent
    def initialize(description, parent)
      @description = description
      @parent = parent
      @givens = []
      @whens = []
      @invariants = []
      @thens = []
      @contexts = []
      @ondones = []
    end

    def add_context(description)
      @contexts << self.class.new(description, self)
      @contexts.last
    end

    def add_given(name, block)
      @givens << Given.new(name, block)
    end

    def add_when(name, block)
      @whens << When.new(name, block)
    end

    def add_invariant(block)
      @invariants << Invariant.new(block)
    end

    def add_then(block)
      @thens << Then.new(block)
    end

    def add_ondone(block)
      @ondones << OnDone.new(block)
    end

    def apply_givens(this)
      @parent.apply_givens(this) if @parent
      @givens.each { |g| g.apply(this) }
    end

    def apply_whens(this)
      @parent.apply_whens(this) if @parent
      @whens.each { |w| w.apply(this) }
    end

    def apply_invariants(this)
      @parent.apply_invariants(this) if @parent
      @invariants.each { |i| i.apply(this) }
    end

    def new_object
      @this = Object.new
    end

    def run_tests
      @thens.each { |t| t.execute(self) }
      @contexts.each { |c| c.run_tests }
      @ondones.each { |d| d.apply(@this) }
    end
  end

  class Given
    def initialize(name, block)
      @name = name
      @block = block
    end
    def apply(this)
      result = this.instance_eval &@block
      this.instance_variable_set "@#{@name.to_s}", result if @name
    end
  end

  class When
    def initialize(name, block)
      @name = name
      @block = block
    end
    def apply(this)
      result = this.instance_eval &@block
      this.instance_variable_set "@#{@name.to_s}", result if @name
    end
  end

  class Invariant
    def initialize(block)
      @block = block
    end
    def apply(this)
      this.instance_eval &@block
    end
  end

  class Then
    def initialize(block)
      @block = block
    end
    def execute(context)
      this = context.new_object
      context.apply_givens(this)
      context.apply_whens(this)
      context.apply_invariants(this)
      this.instance_eval &@block
    end
  end

  class OnDone
    def initialize(block)
      @block = block
    end
    def apply(this)
      this.instance_eval &@block
    end
  end
end
