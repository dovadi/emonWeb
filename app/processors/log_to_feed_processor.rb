class LogToFeedProcessor < Processor

  def self.store?
    true
  end

  def perform
    DataStore.create(:value => @value,:identified_by => @argument)
  end

end