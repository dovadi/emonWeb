require File.dirname(__FILE__) + '/../spec_helper'

describe FeedExtractor do

  before(:each) do
    @input = Input.create!( :name => 'actual_electra', :last_value => 252.55)
    @input.define_processor!(:log_to_feed, 'Electra (Actueel')
    @extractor = FeedExtractor.new(Feed.all, [:actual_electra, :gas_usage])
  end

  it 'should return the correct values' do
    @extractor.values.should == {:actual_electra => 252.55}
  end

end
