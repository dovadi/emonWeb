class Api::V1::DataStoresController < ApplicationController

  def index
    if correct_parameters? && allowed?(params[:api_read_token], params[:feed_id])
      respond_to do |type|
        type.js { render :json => DataStore.fetch(extract(params)).to_json}
      end
    else
      render :nothing => true
    end
  end

  private

  def allowed?(api_read_token, feed_id)
    begin
      feed = Feed.find(feed_id)
      feed.user.api_read_token == api_read_token
    rescue ActiveRecord::RecordNotFound
      false
    end
  end

  def extract(params)
    if correct_parameters? 
      {:from => params[:from].to_i / 1000, :till => params[:till].to_i / 1000, :feed_id => params[:feed_id].to_i}
    end
  end

  def correct_parameters?
    params[:from] && params[:till] && params[:feed_id]
  end
end