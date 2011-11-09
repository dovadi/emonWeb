class PowerToKwhProcessor < LogToFeedProcessor

  def self.description
    'Power to kWh'
  end

  def perform
    @value = calculate!
    super
  end

  private

  def calculate!
    last_kwh = feed.last_value
    time_elapsed = Time.now - feed.updated_at
    kwh_inc = (time_elapsed * @value) / 3600000
    last_kwh + kwh_inc
  end

  def feed
    @feed ||= Feed.find(@argument)
  end
end
