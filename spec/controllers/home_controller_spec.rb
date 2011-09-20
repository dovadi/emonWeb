require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController do

  describe "visitor GET 'index'" do
    before do
      get 'index'
    end
    it { should redirect_to new_user_session_path }
  end

  describe "user GET 'index'" do
    before do
      @user = Factory(:user)
      sign_in @user
      get 'index'
    end
    it { should respond_with :success}
  end

end
