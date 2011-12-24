class DataAverage

  def self.calculate!(identified_by, timeslot)
    return nil unless timeslot.present?
    last  = DataStore.from(identified_by, timeslot).last
    if last
      value = DataStore.from(identified_by).where('created_at >= ? ',last.created_at).average(:value)
    else
      value = DataStore.from(identified_by).average(:value)
    end
    unless value.nil?
      ds = DataStore.create!(:value => value, :identified_by => identified_by, :timeslot => timeslot)
      calculate!(identified_by, Calculator.next(timeslot, ds.created_at))
    end
  end

end