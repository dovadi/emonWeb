require File.dirname(__FILE__) + '/../spec_helper'

describe Feed do

  it 'should be valid' do
    @feed = Feed.create!(:last_value => 252.55, :name => 'electra', :input_id => 3, :user_id => 1)
    @feed.should be_valid
  end

  it { should belong_to :input}
  it { should belong_to :user}

end
