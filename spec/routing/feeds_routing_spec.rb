require File.dirname(__FILE__) + '/../spec_helper'

describe FeedsController do

  describe 'routing' do

    it 'routes to #index' do
      get('/feeds').should route_to(:controller => 'feeds', :action => 'index')
    end

    it 'routes to #show' do
      get('/feeds/1').should route_to(:controller => 'feeds', :action => 'show', :id => '1')
    end

    it 'routes to #graph' do
      get('/feeds/1/graph').should route_to(:controller => 'feeds', :action => 'graph', :id => '1')
    end

  end

end