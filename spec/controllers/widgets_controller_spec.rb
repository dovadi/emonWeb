require File.dirname(__FILE__) + '/../spec_helper'

describe WidgetsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe "GET 'dial' with an id" do
    before(:each) do
      sign_in @user

      @feed = mock
      @feed.expects(:id).returns(2)

      feeds = mock
      feeds.expects(:find).with('2').returns(@feed)

      subject.current_user.expects(:feeds).returns(feeds)
      get 'dial', {:id => '2'}
    end
    it { assigns(:id).should == 2 }
    it { should respond_with :success}
    it { should render_template('layouts/widgets')}
  end

  describe "GET 'dial' without an id and returns by default its first feed" do
    before(:each) do
      sign_in @user

      @feed = mock
      @feed.expects(:id).returns(3)

      ordered_feeds = mock
      ordered_feeds.expects(:first).returns(@feed)

      order = mock

      feeds = mock
      feeds.expects(:find).with(nil).raises(ActiveRecord::RecordNotFound)
      feeds.expects(:order).with(:id).returns(ordered_feeds)

      subject.current_user.expects(:feeds).twice.returns(feeds)
      get 'dial'
    end
    it { assigns(:id).should == 3 }
    it { should respond_with :success}
    it { should render_template('layouts/widgets')}
  end

  describe "GET 'dial' with wrong id returns by default its first feed" do
    before(:each) do
      sign_in @user

      @feed = mock
      @feed.expects(:id).returns(3)

      ordered_feeds = mock
      ordered_feeds.expects(:first).returns(@feed)

      order = mock

      feeds = mock
      feeds.expects(:find).with('99').raises(ActiveRecord::RecordNotFound)
      feeds.expects(:order).with(:id).returns(ordered_feeds)

      subject.current_user.expects(:feeds).twice.returns(feeds)
      get 'dial', {:id => 99}
    end
    it { assigns(:id).should == 3 }
    it { should respond_with :success}
    it { should render_template('layouts/widgets')}
  end


 # feed = current_user.feeds.order(:id).first

end
