# Works only if assigned to the gas_last_reading input.
# Assumes fixed names as gas_usage adn gas_last_reading.
class GasStorageProcessor < Processor
  
  def self.store?
     true
  end

  def self.description
    'Deprecated'
  end

  def perform
    @value
  end

end
