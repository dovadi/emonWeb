require File.dirname(__FILE__) + '/../spec_helper'

describe Feed do

  it 'should be valid' do
    @feed = Feed.create!(:value   => 252.55)
    @feed.should be_valid
  end

  describe 'Feed assigned to table with a suffix based on a identifier' do
    before(:each) do
      @attr = {:value => 252.55, :identified_by => '236'}
    end

    it 'should set the correct table_name' do
      Feed.expects(:table_name=).with('feed_236')
      Feed.expects(:table_name=).with('feeds')
      Feed.create(@attr)
    end
  end

end
