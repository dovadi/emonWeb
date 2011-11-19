require File.dirname(__FILE__) + '/../spec_helper'

describe GraphsController do

  describe 'routing' do

    it 'routes to #bar' do
      get('/graphs/bar').should route_to(:controller => 'graphs', :action => 'bar')
    end

    it 'routes to #realtime' do
      get('/graphs/realtime').should route_to(:controller => 'graphs', :action => 'realtime')
    end

    it 'routes to #raw' do
      get('/graphs/raw').should route_to(:controller => 'graphs', :action => 'raw')
    end

  end

end