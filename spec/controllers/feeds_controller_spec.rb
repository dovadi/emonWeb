require File.dirname(__FILE__) + '/../spec_helper'

describe FeedsController do

  before(:each) do
    @user = Factory(:user)
  end

  describe "visitor GET 'index'" do
    before do
      get 'index'
    end
    it { should redirect_to new_user_session_path }
  end

  describe "user GET 'index'" do
    before do
      sign_in @user
      @feeds = mock
      subject.current_user.expects(:feeds).returns(@feeds)
      get 'index'
    end

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

    it 'should assign the correct feeds' do
      assigns(:feeds).should == @feeds
    end
    it { should respond_with :success}
  end

end
