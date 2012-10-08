class DifferenceProcessor < Processor
  
  def self.store?
     true
  end

  def self.description
    'Only store the value is different than last one'
  end

  def perform
    feed = Feed.find(@argument)
    last_value = feed.last_value ? feed.last_value : 0
    difference = (@value - last_value).round(3)
    unless difference == 0
      DataStore.create(:value => difference, :identified_by => @argument)
      Feed.update(@argument, :last_value => @value)
    end
    difference
  end

end