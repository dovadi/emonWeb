require File.dirname(__FILE__) + '/../../../spec_helper'

describe Api::V1::InputsController do
  describe "routing" do

    it "routes to #index" do
      get("/api/v1/inputs").should route_to("api/v1/inputs#index")
    end

    it "routes to #new" do
      get("/api/v1/inputs/new").should route_to("api/v1/inputs#new")
    end

    it "routes to #show" do
      get("/api/v1/inputs/1").should route_to("api/v1/inputs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/api/v1/inputs/1/edit").should route_to("api/v1/inputs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/api/v1/inputs").should route_to("api/v1/inputs#create")
    end

    it "routes to #update" do
      put("/api/v1/inputs/1").should route_to("api/v1/inputs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/api/v1/inputs/1").should route_to("api/v1/inputs#destroy", :id => "1")
    end

  end

  describe "Named routing for compatibilty with emoncms" do
    it "routes to #create" do
      post("/api").should route_to("api/v1/inputs#api")
    end
  end
end
