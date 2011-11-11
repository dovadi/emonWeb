class FeedsController < ApplicationController

  def index
    @feeds = current_user.feeds
  end

end
