require File.dirname(__FILE__) + '/../spec_helper'

describe Reset do
  it { should validate_presence_of :user_id }
  it { should belong_to :user }
  
  it 'should be valid' do
    Reset.create!(:user_id => 123, :reason => 'memory')
  end
end