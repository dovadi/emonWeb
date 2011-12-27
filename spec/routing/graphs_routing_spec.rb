require File.dirname(__FILE__) + '/../spec_helper'

describe GraphsController do

  describe 'routing' do

    it 'routes to #bar' do
      get('/graphs/bar').should route_to(:controller => 'graphs', :action => 'bar')
    end

    it 'routes to #real_time' do
      get('/graphs/real_time').should route_to(:controller => 'graphs', :action => 'real_time')
    end

    it 'routes to #raw' do
      get('/graphs/raw').should route_to(:controller => 'graphs', :action => 'raw')
    end

  end

end