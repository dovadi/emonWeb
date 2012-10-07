class FeedsController < ApplicationController

  before_filter :determine_feed, :only =>[:graph]

  def index
    @feeds = current_user.feeds
    respond_to do |type|
      type.js do
        render :json => FeedExtractor.new(@feeds, [:actual_electra, :gas_usage]).values.to_json 
      end
      type.html { render :index }
    end

   end

  def show
    @feed = current_user.feeds.find(params[:id])
    respond_to do |type|
       type.js { render :json => @feed.to_json }
    end
  end

  def graph
    case params[:type]
    when 'bar'
      render :template => '/feeds/bar'
    when 'real_time'
      render :template => '/feeds/real_time'
    else
      render :template => '/feeds/raw'
    end
  end
  
  private

  def determine_feed
    @feed = begin
      current_user.feeds.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      current_user.feeds.first
    end
  end

end
