class ScaleProcessor

  attr_accessor :value, :argument

  def initialize(value, argument)
    @value    = value
    @argument = argument
  end

  def perform
    value * argument
  end
end

