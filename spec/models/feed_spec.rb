require File.dirname(__FILE__) + '/../spec_helper'

describe Feed do

  before(:each) do
    @attr = { 
      :value   => 252.55,
      :user_id => 100,
      :input_id => 1
    }
  end

  it { should belong_to :user }
  it { should belong_to :input }

  it 'should be valid' do
    @feed = Feed.create!(@attr)
    @feed.should be_valid
  end

end
