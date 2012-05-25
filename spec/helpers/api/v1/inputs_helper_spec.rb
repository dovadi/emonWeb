require File.dirname(__FILE__) + '/../../../spec_helper'


describe Api::V1::InputsHelper do
  describe "Name of processor" do
    it "should show feed in case of a processor which acts as a data store" do
      feed = Feed.create!(:last_value => 252.55, :name => 'electra', :input_id => 3, :user_id => 1)
      processor = [:log_to_feed, feed.id]
      helper.name_of_processor(processor).should == 'Feed'
    end

    it "should show the description of a processor if no data_store is associated" do
      processor = [:scale, 1.0005]
      helper.name_of_processor(processor).should == 'Scale'
    end
  end

  describe "Argument of processor" do
    it "should show the name of the feed in case of a processor which acts as a data store" do
      feed = Feed.create!(:last_value => 252.55, :name => 'electra', :input_id => 3, :user_id => 1)
      processor = [:log_to_feed, feed.id]
      helper.argument_of_processor(processor).should == 'electra'
    end

    it "should show the argument of a processor if no data_store is associated" do
      processor = [:scale, 1.0005]
      helper.argument_of_processor(processor).should == 1.0005
    end
  end
end
