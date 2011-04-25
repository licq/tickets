require 'spec_helper'

describe AgentRfpsController do

   before(:each) do
    Spot.delete_all
    User.delete_all
    City.delete_all
    Season.delete_all
    Ticket.delete_all
    AgentPrice.delete_all
    Agent.delete_all
    Rfp.delete_all
    @rfp = Factory(:rfp)
    @agent_operator = Factory(:agent_operator, :agent => @rfp.agent)
    test_login(@agent_operator)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end



  describe "POST 'create'" do
    it "should be successful" do
      post 'create'
      response.should be_success
    end
  end


  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete 'destroy', :id => @rfp.id
      response.should redirect_to(agent_rfps_url)
    end
  end

end
