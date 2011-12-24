class Calculator

  def self.next(timeslot, time)
    case timeslot
    when :one_min
      :five_mins    if time.min  %  5 ==  0
    when :five_mins
      :fifteen_mins if time.min  % 15 ==  0
    when :fifteen_mins
      :one_hour     if time.min        < 15
    when :one_hour
      :four_hours   if time.hour %  4 ==  0
    when :four_hours
      :twelve_hours if time.hour % 12 ==  0
    end
  end

end