class PowerToKwhPerDayProcessor < PowerToKwhProcessor

  def self.description
    'Power to kWh/d'
  end

  def perform
    data_store = DataStore.from('data_store_' + @argument.to_s).where(:created_at => Date.today)
    if data_store
      @value = calculate!
      data_store.update_attributes(attributes)
    else
      @value = 0
      DataStore.create(attributes)
    end
    @value
  end

  private

  def attributes
    {:value => @value, :identified_by => @argument, :created_at => Date.today}
  end
end