require File.dirname(__FILE__) + '/../spec_helper'

describe TokenAuthenticationsController  do

  describe 'routing' do

    it "routes to #create" do
      post('/token_authentications').should route_to(:controller => 'token_authentications', :action => 'create')
    end

    it "routes to #destroy" do
      delete('/token_authentications/1').should route_to(:controller => 'token_authentications', :action => 'destroy', :id => '1' )
    end

  end

end
