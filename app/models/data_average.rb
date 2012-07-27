class DataAverage

  def self.calculate!(identified_by, timeslot)
    return nil unless timeslot.present?
    last  = DataStore.from(identified_by.to_i, timeslot).last
    if last
      value = DataStore.from(identified_by.to_i).where('created_at >= ? ',last.created_at).average(:value)
    else
      value = DataStore.from(identified_by.to_i).average(:value)
    end
    unless value.nil?
      # Force assigning created_at to prevent stange error with MySql: Mysql2::Error: Column 'created_at' cannot be null
      ds = DataStore.create!(:value => value, :identified_by => identified_by, :timeslot => timeslot, :created_at => Time.now.utc)
      calculate!(identified_by.to_i, Calculator.next(timeslot, ds.created_at))
    end
  end

end