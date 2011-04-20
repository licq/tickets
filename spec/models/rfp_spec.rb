require File.dirname(__FILE__) + '/../spec_helper'

describe Rfp do

  before(:each) do
    Ticket.delete_all
    User.delete_all
    City.delete_all
    Spot.delete_all
    Season.delete_all
    Agent.delete_all
    AgentPrice.delete_all
    Rfp.delete_all
  end

  it "should be valid" do
    Factory.build(:rfp).should be_valid
  end

  it "should require spot" do
    Factory.build(:rfp, :spot_id => nil).should have(1).error_on(:spot_id)
  end

  it "should require agent" do
    Factory.build(:rfp, :agent_id => nil).should have(1).error_on(:agent_id)
  end

  it "should require agent_price if from_spot" do
    Factory.build(:rfp, :from_spot => true, :agent_price_id => nil).should have(1).error_on(:agent_price_id)
  end

  it "should validate uniqueness of spot and agent when status is applied" do
    rfp = Factory(:rfp, :spot_id => 3, :agent_id => 3, :status => "a")
    Factory.build(:rfp, :spot => rfp.spot, :agent => rfp.agent, :status => "a").should_not be_valid
  end

  it "should accept same spot and agent when status is rejected" do
    rfp = Factory(:rfp, :spot_id => 3, :agent_id => 3, :status => "r")
    Factory.build(:rfp, :spot => rfp.spot, :agent => rfp.agent, :status => "a").should_not be_valid
  end

   it "should return correct connected size when status is c" do
    spot1 = Factory(:spot)
    spot2 = Factory(:spot)
    agent1 = Factory(:agent, :name => "agent1")
    agent2 = Factory(:agent, :name => "agent2")
    agent_price1 = Factory(:agent_price , :spot => spot1)
    agent_price2 = Factory(:agent_price , :spot => spot2)
    Factory(:rfp, :spot => spot1, :agent => agent1, :agent_price =>agent_price1 , :status => "c")
    Factory(:rfp, :spot => spot2, :agent => agent2, :agent_price =>agent_price2 , :status => "c")
    Rfp.connected.size.should == 2
    spot2.rfps.connected.size.should == 1
  end

end
