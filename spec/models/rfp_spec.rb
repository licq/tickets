require File.dirname(__FILE__) + '/../spec_helper'

describe Rfp do

  before(:each) do
    Ticket.delete_all
    User.delete_all
    City.delete_all
    Spot.delete_all
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
    Factory(:rfp, :spot_id => 3, :agent_id => 3, :status => "a")
    Factory.build(:rfp, :spot_id => 3, :agent_id => 3, :status => "a").should_not be_valid
  end

  it "should accept same spot and agent when status is rejected" do
    Factory(:rfp, :spot_id => 3, :agent_id => 3, :status => "r")
    Factory.build(:rfp, :spot_id => 3, :agent_id => 3, :status => "a").should_not be_valid
  end

end
