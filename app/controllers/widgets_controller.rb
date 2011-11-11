class WidgetsController < ApplicationController

  def dial
    begin
      feed = current_user.feeds.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      feed = current_user.feeds.first
    end
    @id = feed.id if feed
  end

end
