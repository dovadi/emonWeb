require 'spec_helper'

describe GraphsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe 'GET realtime' do
    it 'should be successful' do
      get 'real_time'
      response.should be_success
    end
  end

  describe 'GET raw' do
    it 'should be successful' do
      get 'raw'
      response.should be_success
    end
  end

  describe 'GET bar' do
    it 'should be successful' do
      get 'bar'
      response.should be_success
    end
  end

end
