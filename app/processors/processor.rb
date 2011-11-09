class Processor

  attr_accessor :value, :argument

  def self.store?
    false
  end

  def initialize(value, argument)
    @value    = value
    @argument = argument
  end

end