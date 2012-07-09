require File.dirname(__FILE__) + '/../spec_helper'

describe Reset do
  before(:each) do
    @user = User.create!(:email => 'user@example.com', :password => 'foobar', :password_confirmation => 'foobar')
  end

  it { should validate_presence_of :user_id }
  it { should belong_to :user }
  
  it 'should be valid' do
    Reset.create!(:user_id => @user.id, :reason => 'memory')
  end

  it 'should deliver a notification by email' do
    expect do
      @user.resets.create!(:reason => 'UNK')
    end.to change(ActionMailer::Base.deliveries, :count).by(1)
  end
end