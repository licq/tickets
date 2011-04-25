require File.dirname(__FILE__) + '/../spec_helper'

describe Agent do
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
    Factory.build(:agent).should be_valid
  end

  it "should require a name" do
    Factory.build(:agent, :name=> "").should have(1).error_on(:name)
  end

  it "should reject if name exists" do
    Factory(:agent, :name => "uniquename")
    Factory.build(:agent, :name => "uniquename").should have(1).error_on(:name)
  end

  it "should require an agent_operator" do
    Factory.build(:agent, :operator => nil).should have(1).error_on(:operator)
  end


  it "should return correct not_connected_with_spot size " do
    agent1 = Factory(:agent, :name =>"agent1")
    agent2 = Factory(:agent, :name =>"agent2")
    spot = Factory(:spot)
    Factory(:rfp, :spot => spot, :agent => agent1)
    Agent.not_connected_with_spot(spot).size.should == 1
  end


end
