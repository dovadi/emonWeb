require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController do

  describe 'routing' do

    it 'routes to #index' do
      get("/").should route_to(:controller => 'home', :action => 'index')
    end

  end

end