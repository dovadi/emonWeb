class Api::V1::DataStoresController < ApplicationController

  def index
    if correct_parameters?
      respond_to do |type|
        type.js { render :json => DataStore.fetch(extract(params)).to_json}
      end
    else
      render :nothing => true
    end
  end

  private

  def extract(params)
    if correct_parameters? 
      {:start => params[:start].to_i, :end => params[:end].to_i, :api_read_token => params[:api_read_token], :feed_id => params[:feed_id].to_i}
    end
  end
  
  def correct_parameters?
    params[:start] && params[:end] && params[:api_read_token] && params[:feed_id]
  end
end