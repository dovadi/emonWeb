require File.dirname(__FILE__) + '/../spec_helper'

describe WidgetsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe "GET 'dial'" do
    before(:each) do
      sign_in @user
      get 'dial'
    end
    it { should respond_with :success}
    it { should render_template('dial')}
  end

end
