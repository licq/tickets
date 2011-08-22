require 'spec_helper'

describe AlipayControllerController do

  describe "GET 'pay'" do
    it "should be successful" do
      get 'pay'
      response.should be_success
    end
  end

  describe "GET 'return'" do
    it "should be successful" do
      get 'return'
      response.should be_success
    end
  end

  describe "GET 'notify'" do
    it "should be successful" do
      get 'notify'
      response.should be_success
    end
  end

end
