require File.dirname(__FILE__) + '/../spec_helper'

describe TokenAuthenticationsController  do

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "POST 'create'" do
    before do
      post 'create', :user_id => @user.id
    end
    it "should create a new authentication token and api read token" do
      @user.reload.authentication_token.should_not be_nil
      @user.api_read_token.should_not be_nil
    end
    it { should respond_with :redirect }
    it { should redirect_to edit_user_registration_path(@user)}
  end

  describe "DELETE 'destroy'" do
    before do
      @user.reset_api_read_token
      @user.reset_authentication_token!
      delete 'destroy', :id => @user.id
    end
    it "should destroy the authentication token" do
      @user.reload.authentication_token.should be_nil
      @user.api_read_token.should be_nil
    end
    it { should redirect_to edit_user_registration_path(@user)}
  end

end
