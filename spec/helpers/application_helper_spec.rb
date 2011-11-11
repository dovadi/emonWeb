require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do

  describe 'color_time_age' do
    before(:each) do
      Time.zone.stubs(:now).returns(1321012900)
    end
    it 'should return green if time difference is smaller than 30 seconds' do
      helper.color_time_ago(Time.at(1321012885)).should == 'green'
    end
    it 'should return orange if time difference is between 30 and  60 seconds' do
      helper.color_time_ago(Time.at(1321012855)).should == 'orange'
    end
    it 'should return red if time difference is larger than 60 seconds' do
      helper.color_time_ago(Time.at(1321012839)).should == 'red'
    end
  end

end
