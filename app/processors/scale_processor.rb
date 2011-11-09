class ScaleProcessor < Processor

  def self.description
    'Scale'
  end

  def perform
    value * argument
  end

end
