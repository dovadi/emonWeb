require File.dirname(__FILE__) + '/../spec_helper'

describe WidgetsHelper do

  describe 'dial javascript' do
    it 'should return the javascript for rendering the dial' do
      helper.dial_javascript(3).class.should == String
    end
  end

end
