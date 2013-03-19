require File.dirname(__FILE__) + '/../spec_helper'

describe FeedsController do

  before(:each) do
    @user = FactoryGirl.create(:user, :time_zone => 'Lisbon')
  end

  describe 'visitor GET index' do
    before do
      get 'index'
    end
    it { should redirect_to new_user_session_path }
  end

  describe 'user GET index' do
    before do
      sign_in @user
      @feeds = mock
      subject.current_user.should_receive(:feeds).and_return(@feeds)
      get 'index'
    end

    it 'should have a current_user' do
      subject.current_user.should_not be_nil
    end

    it 'should set the correct time zone' do
      Time.zone.to_s.should == '(GMT+00:00) Lisbon'
    end

    it 'should assign the correct feeds' do
      assigns(:feeds).should == @feeds
    end
    it { should respond_with :success}
  end

  describe 'user GET index json' do
    before do
      sign_in @user
      @feeds = mock
      subject.current_user.should_receive(:feeds).and_return(@feeds)
      values = mock(:values => {:actual_electra => 100})
      FeedExtractor.should_receive(:new).with(@feeds, [:actual_electra, :gas_usage]).and_return(values)
      xhr :get, :index, :format => :js
    end
    it { should respond_with :success}
    it { response.body.should == {:actual_electra => 100}.to_json }
  end

  describe 'user GET show' do
    before do
      sign_in @user

      @feed = mock
      @feed.should_receive(:to_json)

      feeds = mock
      feeds.should_receive(:find).with('1').and_return(@feed)

      subject.current_user.should_receive(:feeds).and_return(feeds)

      xhr :get, :show, :id => 1, :format => 'js'
    end

    it 'should have a current_user' do
      subject.current_user.should_not be_nil
    end

    it 'should assign the correct feed' do
      assigns(:feed).should == @feed
    end
    it { should respond_with :success}
  end


  describe 'user GET graph' do
    before do
      sign_in @user

      @feed = mock
      
      feeds = mock
      feeds.should_receive(:find).with('1').and_return(@feed)

      subject.current_user.should_receive(:feeds).and_return(feeds) 
    end

    describe 'raw data' do
      before do
        get 'graph', :id => 1
      end

      it 'should assign the correct feed' do
        assigns(:feed).should == @feed
      end
      it { should respond_with :success}
      it { should render_template 'raw'}
    end

    describe 'real time' do
      before do
        get 'graph', :id => 1, :type => 'real_time'
      end

      it 'should assign the correct feed' do
        assigns(:feed).should == @feed
      end
      it { should respond_with :success}
      it { should render_template 'real_time'}
    end

    describe 'bar' do
      before do
        get 'graph', :id => 1, :type => 'bar'
      end

      it 'should assign the correct feed' do
        assigns(:feed).should == @feed
      end
      it { should respond_with :success}
      it { should render_template 'bar'}
    end

  end

end
