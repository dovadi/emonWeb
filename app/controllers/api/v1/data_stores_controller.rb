class Api::V1::DataStoresController < ApplicationController

  def index
    if allowed?(params[:api_read_token]) && correct_parameters? 
      respond_to do |type|
        type.js { render :json => DataStore.fetch(extract(params)).to_json}
      end
    else
      render :nothing => true
    end
  end

  private

  def allowed?(api_read_token)
    current_user.api_read_token == api_read_token
  end

  def extract(params)
    if correct_parameters? 
      {:from => params[:from].to_i, :till => params[:till].to_i, :feed_id => params[:feed_id].to_i}
    end
  end

  def correct_parameters?
    params[:from] && params[:till] && params[:feed_id]
  end
end