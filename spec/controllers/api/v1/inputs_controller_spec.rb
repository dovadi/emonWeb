require File.dirname(__FILE__) + '/../../../spec_helper'

describe Api::V1::InputsController do

  def valid_attributes
    { 
      :name => 'power',
      :last_value => 252.4,
    }
  end

  before(:each) do
    @user = Factory(:user)
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
