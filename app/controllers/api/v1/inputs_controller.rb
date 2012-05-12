class Api::V1::InputsController < ApplicationController

  protect_from_forgery :except => [:api]

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
    if params['P1'].present?
      p1 = ParseP1::Base.new(params['P1'])
      extract_p1_attributes!(p1) if p1.valid?
    end
    Input.create_or_update(params.merge!(:user_id => current_user.id).to_hash)
    render :nothing => true 
  end

  def destroy
    @input = current_user.inputs.find(params[:id])
    @input.destroy
    redirect_to api_v1_inputs_url
  end

  private

  def extract_p1_attributes!(p1)
    params.delete('P1')
    params.merge!(:actual_electra               => p1.electricity(:type => :import, :actual => true),
                  :electra_import_normal_tariff => p1.electricity(:type => :import, :tariff => :normal),
                  :electra_import_low_tariff    => p1.electricity(:type => :import, :tariff => :low),
                  :electra_export_normal_tariff => p1.electricity(:type => :export, :tariff => :normal),
                  :electra_export_low_tariff    => p1.electricity(:type => :export, :tariff => :low),
                  :gas_usage                    => p1.gas_usage, #Gas usage needs allways be stored before gas_last_reading
                  :gast_last_reading            => p1.last_hourly_reading_gas.to_f)

  end

end
