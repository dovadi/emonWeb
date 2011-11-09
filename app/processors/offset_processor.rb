class OffsetProcessor < Processor

  def self.description
    'Offset'
  end

  def perform
    value + argument
  end

end
