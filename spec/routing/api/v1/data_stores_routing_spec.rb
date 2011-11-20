require File.dirname(__FILE__) + '/../../../spec_helper'

describe Api::V1::DataStoresController do
  describe 'routing' do

    it 'routes to #index' do
      get('/api/v1/data_stores').should route_to('api/v1/data_stores#index')
    end
  end
end