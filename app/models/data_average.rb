class DataAverage


  def self.calculate!(identified_by, timeslot)
    last  = DataStore.from(identified_by, timeslot).last
    if last
      value = DataStore.from(identified_by).where('created_at >= ? ',last.created_at).average(:value)
    else
      value = DataStore.from(identified_by).average(:value)
    end
    DataStore.create(:value => value, :identified_by => identified_by, :timeslot => timeslot)
    calculate_next_average(identified_by, timeslot, last) if last
  end

  private

  def self.calculate_next_average(identified_by, timeslot, last)
    case timeslot
    when :one_min
      self.calculate!(identified_by, :five_mins)    if last.created_at.min % 5   == 0
    when :five_mins
      self.calculate!(identified_by, :fifteen_mins) if last.created_at.min % 15  == 0
    when :fifteen_mins
      self.calculate!(identified_by, :one_hour)     if last.created_at.min       == 0
    when :one_hour
      self.calculate!(identified_by, :four_hours)   if last.created_at.hour % 4  == 0
    when :four_hour
      self.calculate!(identified_by, :twelve_hours) if last.created_at.hour % 12 == 0
    end
  end

end