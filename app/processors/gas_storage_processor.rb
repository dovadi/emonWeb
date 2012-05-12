# Works only if assigned to the gas_last_reading input.
# Assumes fixed names as gas_usage adn gas_last_reading.
class GasStorageProcessor < Processor
  
  def self.store?
     true
  end

  def self.description
    'Store gas usage once an hour'
  end

  def perform
    user = Feed.find(@argument).user
    if user
      last_time = user.inputs.find_by_name('gas_last_reading')
      gas_usage = user.inputs.find_by_name('gas_usage')
      if gas_usage && (last_time.nil? || last_time.last_value + 3600 < @value)
        DataStore.create(:value => gas_usage.last_value, :identified_by => gas_usage.id)
      end
    end
    Feed.update(@argument, :last_value => @value)
    @value
  end

end
