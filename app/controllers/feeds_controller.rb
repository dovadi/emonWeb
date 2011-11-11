class FeedsController < ApplicationController

  def index
    @feeds = current_user.feeds
  end

  def show
    @feed = current_user.feeds.find(params[:id])
    respond_to do |type|
       type.js { render :json => @feed.to_json }
    end
  end
end
