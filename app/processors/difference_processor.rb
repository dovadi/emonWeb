class DifferenceProcessor < Processor
  
  def self.store?
     true
  end

  def self.description
    'Only store the value is different than last one'
  end

  def perform
    feed = Feed.find(@argument)
    last_value = feed.last_value

    if @value != last_value
      DataStore.create(:value => @value, :identified_by => @argument)
      Feed.update(@argument, :last_value => @value)
    end
    @value
  end

end