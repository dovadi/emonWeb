class LogToFeedProcessor < Processor

  def self.store?
    true
  end

  def self.description
    'Log to Feed'
  end

  def perform
    DataStore.create(:value => @value,:identified_by => @argument)
    @value
  end

end