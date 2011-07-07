require 'spec_helper'

describe ManualsController do

  describe "GET 'spot'" do
    it "should be successful" do
      get 'spot'
      response.should be_success
    end
  end

  describe "GET 'agent'" do
    it "should be successful" do
      get 'agent'
      response.should be_success
    end
  end

end
