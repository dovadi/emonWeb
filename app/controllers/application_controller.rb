class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :set_time_zone

  private

  def set_time_zone
    Time.zone = current_user.time_zone if current_user && current_user.time_zone.present?
  end
end
