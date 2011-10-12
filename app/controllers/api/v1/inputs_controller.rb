class Api::V1::InputsController < ApplicationController
  protect_from_forgery :except => [:create]

  def index
    @inputs = current_user.inputs
  end

  def new
    @input = Input.new
  end

  def create
    @input = current_user.inputs.new(params[:input])
    if @input.save
      redirect_to api_v1_inputs_path, notice: 'Input was successfully created.'
    else
      render action: "new" 
    end
  end

  def api
    Input.create_or_update(params.merge!(:user_id => current_user.id).to_hash)
    render :nothing => true 
  end

  def destroy
    @input = current_user.inputs.find(params[:id])
    @input.destroy
    redirect_to api_v1_inputs_url
  end

end
