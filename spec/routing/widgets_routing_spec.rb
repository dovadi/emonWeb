require File.dirname(__FILE__) + '/../spec_helper'

describe WidgetsController do

  describe 'routing' do

    it 'routes to #dial' do
      get('/widgets/dial').should route_to(:controller => 'widgets', :action => 'dial')
    end

  end

end