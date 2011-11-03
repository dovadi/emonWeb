class MultiplyProcessor

  attr_accessor :value, :args

  def initialize(value, args)
    @value = value
    @args  = args
  end

  def perform
    value * args[0]
  end
end

