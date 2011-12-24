class TimeslotSelector

  TOTAL_PIXELS   = 800
  
  def self.determine(options = {})
    from = options[:from]
    till = options[:till]
    
    if from && till
      distance = (till - from)
      if    distance - ten_sec      < 0
        nil
      elsif distance - one_min      < 0
        :one_min
      elsif distance - five_mins    < 0
        :five_mins
      elsif distance - fifteen_mins < 0
        :fifteen_mins
      elsif distance - one_hour     < 0
        :one_hour
      elsif distance - four_hours   < 0
        :four_hours
      else
        :twelve_hours
      end
    end
  end

  private

  def self.ten_sec
    10 * TOTAL_PIXELS
  end

  def self.one_min
    6 * ten_sec
  end

  def self.five_mins
    5 * one_min
  end

  def self.fifteen_mins
    3 * five_mins
  end

  def self.one_hour
    4 * fifteen_mins
  end

  def self.four_hours
    4 * one_hour
  end

end