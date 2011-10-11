require File.dirname(__FILE__) + '/../../../spec_helper'

describe "Api::V1::Inputs" do

  before(:each) do
    @user = Factory(:user)
    @user.reset_authentication_token!
    @user.reload
  end

  describe "GET /api_v1_inputs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get api_v1_inputs_path(:auth_token => @user.authentication_token)
      response.status.should be(200)
    end
  end

  describe 'POST /api' do
    it 'create new inputs' do
      expect do
        post api_path(:auth_token => @user.authentication_token, :water => 12.35, :solar => 48.23)
      end.to change(Input, :count).by(2)
      response.status.should be(302)
      Input.last.user_id.should be(@user.id)
    end
  end

end
