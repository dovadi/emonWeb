require File.dirname(__FILE__) + '/../../../spec_helper'

describe Api::V1::DataStoresController do

  before(:each) do
    @user = Factory(:user)
    @user.reset_api_read_token!
      sign_in @user
  end

  describe 'GET index' do
    before(:each) do
      get :index, :format => :js
    end
    it { should respond_with :success }
  end

  describe 'GET index with the correct params' do
    it 'should respond with a json object' do
      feed = Feed.create!(:last_value => 252.55, :name => 'electra', :input_id => 3, :user_id => @user.id)
      params  = {:from => 1321813064, :till => 1321816647, :feed_id => feed.id}
      data = mock
      data.expects(:to_json)
      DataStore.expects(:fetch).with(params).returns(data)
      get :index, {:format => :js}.merge(params.merge(:api_read_token => @user.api_read_token))
    end
  end

end