class LogToFeedProcessor < Processor
  
  def self.store?
    true
  end

  def self.description
    'Log to Feed'
  end

  def perform
    DataStore.create(:value => @value,:identified_by => @argument)
    Feed.update(@argument, :last_value => @value)
    @value
  end

end