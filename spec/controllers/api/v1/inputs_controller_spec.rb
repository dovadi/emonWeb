require File.dirname(__FILE__) + '/../../../spec_helper'

describe Api::V1::InputsController do

  def valid_attributes
    { 
      :name => 'power',
      :last_value => 252.4,
    }
  end

  def p1_attributes
    {
      :P1 => "\r\n/ABc1\\1AB123-4567\r\n\r\n0-0:96.1.1(1A123456789012345678901234567890)\r\n1-0:1.8.1(00136.787*kWh)\r\n1-0:1.8.2(00131.849*kWh)\r\n1-0:2.8.1(00002.345*kWh)\r\n1-0:2.8.2(00054.976*kWh)\r\n0-0:96.14.0(0002)\r\n1-0:1.7.0(0003.20*kW)\r\n1-0:2.7.0(0000.12*kW)\r\n0-0:17.0.0(0999.00*kW)\r\n0-0:96.3.10(1)\r\n0-0:96.13.1()\r\n0-0:96.13.0()\r\n0-1:24.1.0(3)\r\n0-1:96.1.0(1234567890123456789012345678901234)\r\n0-1:24.3.0(120502150000)(00)(60)(1)(0-1:24.2.1)(m3)\r\n(00092.112)\r\n0-1:24.4.0(1)\r\n!"
    }
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe 'GET index' do
    it 'assigns all inputs as @inputs' do
      input = @user.inputs.create! valid_attributes
      get :index
      assigns(:inputs).should eq([input])
    end
  end

  describe 'GET new' do
    it 'assigns a new input as @input' do
      get :new
      assigns(:input).should be_a_new(Input)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Input' do
        expect do
          post :create, :input => valid_attributes
        end.to change(Input, :count).by(1)
        Input.last.user_id.should == @user.id
      end

      it 'assigns a newly created input as @input' do
        post :create, :input => valid_attributes
        assigns(:input).should be_a(Input)
        assigns(:input).should be_persisted
      end

      it 'redirects to the created input' do
        post :create, :input => valid_attributes
        response.should redirect_to(api_v1_inputs_path)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved input as @input' do
        Input.any_instance.stubs(:save).returns(false)
        post :create, :input => {}
        assigns(:input).should be_a_new(Input)
      end

      it 're-renders the new template' do
        Input.any_instance.stubs(:save).returns(false)
        post :create, :input => {}
        response.should render_template('new')
      end
    end
  end

  describe 'POST api' do
    it 'creates a new inputs (with the use of a monitoring devices)' do
      expect do
        post :api, { :water => 20.45, :solar => 12.34 }
      end.to change(Input, :count).by(2)
    end

    it 'creates a new inputs with P1 data' do
      expect do
        post :api, p1_attributes
      end.to change(Input, :count).by(7)
    end

    describe 'Creating seven inputs with P1 attributes' do
      before do
        post :api, p1_attributes
      end
      it 'should create an input for actual electra' do
        Input.find_by_name('actual_electra').should be_present
      end
      it 'should create an input for imported electra with a normal tariff' do
        Input.find_by_name('electra_import_normal_tariff').should be_present
      end
      it 'should create an input for imported electra with a low tariff' do
        Input.find_by_name('electra_import_low_tariff').should be_present
      end
      it 'should create an input for exported electra with a normal tariff' do
        Input.find_by_name('electra_export_normal_tariff').should be_present
      end
      it 'should create an input for exported electra with a low tariff' do
        Input.find_by_name('electra_export_low_tariff').should be_present
      end
      it 'should create an input for gas usage' do
        Input.find_by_name('gas_usage').should be_present
      end
      it 'should create an input for gas last reading' do
        Input.find_by_name('gas_last_reading').should be_present
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested input' do
      input = @user.inputs.create! valid_attributes
      expect do
        delete :destroy, :id => input.id.to_s
      end.to change(Input, :count).by(-1)
    end

    it 'redirects to the api_v1_inputs list' do
      input = @user.inputs.create! valid_attributes
      delete :destroy, :id => input.id.to_s
      response.should redirect_to(api_v1_inputs_url)
    end
  end

end
