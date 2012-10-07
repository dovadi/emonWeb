class Api::V1::InputsController < ApplicationController

  protect_from_forgery :except => [:api, :p1]

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
      render action: 'new'
    end
  end

  def api
    #TODO: deprecate P1 records on /api
    if params['P1'].present?
      p1 = ParseP1::Base.new(params['P1'])
      extract_p1_attributes!(p1) if p1.valid?
    end
    Input.create_or_update(params.merge!(:user_id => current_user.id).to_hash)
    render :nothing => true 
  end

  def p1
    current_user.resets.create!(:reason => params['REA']) if params['RST']
    if params['P1'].present?
      p1 = ParseP1::Base.new(params['P1'])
      if p1.valid?
        extract_p1_attributes!(p1) 
        Input.create_or_update(params.slice(*valid_p1_keys).merge!(:user_id => current_user.id).to_hash)
      end
    end
    render :nothing => true 
    # WIP head :accepted, :auth => current_user.authentication_token, :time => 1500
  end

  def update
    input = current_user.inputs.find(params[:id])
    respond_to do |type|
      type.js do
        input.define_processors(params) if input
      end    
    end
  end

  def destroy
    @input = current_user.inputs.find(params[:id])
    @input.destroy
    redirect_to api_v1_inputs_url
  end

  private

  #TODO: push this to input model
  def extract_p1_attributes!(p1)
    params.delete('P1')
    params.merge!(:actual_electra               => p1.electricity(:type => :import, :actual => true),
                  :electra_import_normal_tariff => p1.electricity(:type => :import, :tariff => :normal),
                  :electra_import_low_tariff    => p1.electricity(:type => :import, :tariff => :low),
                  :electra_export_normal_tariff => p1.electricity(:type => :export, :tariff => :normal),
                  :electra_export_low_tariff    => p1.electricity(:type => :export, :tariff => :low),
                  :gas_usage                    => p1.gas_usage, #Gas usage needs allways be stored before gas_last_reading
                  :gas_last_reading             => p1.last_hourly_reading_gas.to_f)

  end

  def valid_p1_keys
    [:actual_electra, :electra_export_low_tariff, :electra_export_normal_tariff, :electra_import_low_tariff,
     :electra_import_normal_tariff, :gas_usage, :gas_last_reading]
  end
end
