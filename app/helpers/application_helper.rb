module ApplicationHelper

  def color_time_ago(time)
    time_diff = Time.zone.now.to_i - Time.zone.parse(time.to_s).to_i 
    if time_diff < 30
      'green'
    elsif time_diff >= 30 && time_diff < 60
      'orange'
    else
      'red'
    end
  end

  def bootstrap_alert(key)
    case key
    when :alert
      ''
    when :notice
      'alert-success'
    else
      'alert-' + key.to_s
    end
  end

end
