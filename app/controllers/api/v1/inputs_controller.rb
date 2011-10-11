class Api::V1::InputsController < ApplicationController
  protect_from_forgery :except => [:create, :update]
  # GET /api/v1/inputs
  # GET /api/v1/inputs.json
  def index
    @inputs = Input.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inputs }
    end
  end

  # GET /api/v1/inputs/1
  # GET /api/v1/inputs/1.json
  def show
    @input = Input.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @input }
    end
  end

  # GET /api/v1/inputs/new
  # GET /api/v1/inputs/new.json
  def new
    @input = Input.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @input }
    end
  end

  # GET /api/v1/inputs/1/edit
  def edit
    @input = Input.find(params[:id])
  end

  # POST /api/v1/inputs
  # POST /api/v1/inputs.json
  def create
    if params[:input]
      @input = Input.new(params[:input])
      respond_to do |format|
        if @input.save
          format.html { redirect_to api_v1_input_path(@input), notice: 'Input was successfully created.' }
          format.json { render json: @input, status: :created, location: @input }
        else
          format.html { render action: "new" }
          format.json { render json: @input.errors, status: :unprocessable_entity }
        end
      end
    else
      Input.create_or_update(params.merge(:user_id => current_user.id).to_hash)
      redirect_to 'index'
    end
  end

  # PUT /api/v1/inputs/1
  # PUT /api/v1/inputs/1.json
  def update
    @input = Input.find(params[:id])

    respond_to do |format|
      if @input.update_attributes(params[:input])
        format.html { redirect_to api_v1_input_path(@input), notice: 'Input was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @input.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v1/inputs/1
  # DELETE /api/v1/inputs/1.json
  def destroy
    @input = Input.find(params[:id])
    @input.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_inputs_url }
      format.json { head :ok }
    end
  end
end
