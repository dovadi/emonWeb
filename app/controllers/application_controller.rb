class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :set_time_zone

  #TODO cover with some sort of test
  rescue_from(ArgumentError) {|e| raise e unless e.message == "invalid byte sequence in UTF-8"}

  private

  def set_time_zone
    Time.zone = current_user.time_zone if current_user && current_user.time_zone.present?
  end
end
