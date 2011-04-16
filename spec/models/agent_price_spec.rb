require File.dirname(__FILE__) + '/../spec_helper'

describe AgentPrice do

  before(:each) do
    Ticket.delete_all
    User.delete_all
    City.delete_all
    Spot.delete_all
    AgentPrice.delete_all
  end

  it "should be valid" do
    Factory.build(:agent_price).should be_valid
  end

  it "should require a name" do
    Factory.build(:agent_price, :name =>"").should_not be_valid
  end

  it "should require a unique name" do
    Factory(:agent_price, :name =>"notuniquename")
    Factory.build(:agent_price, :name =>"notuniquename").should have(1).error_on(:name)
  end

  it "should return the rate for the season" do
    season1 = Factory.build(:season, :name => "season1")
    ticket1 = Factory.build(:ticket, :name => "ticket1")
    season2 = Factory.build(:season, :name => "season2")
    ticket2 = Factory.build(:ticket, :name => "ticket2")
    teamrate1 = TeamRate.new(:adult_price => 100, :child_price => 40, :season => season1, :ticket => ticket1)
    teamrate2 = TeamRate.new(:adult_price => 55, :child_price => 20, :season => season2, :ticket => ticket2)
    agent_price = Factory.build(:agent_price, :team_rates => [teamrate1, teamrate2])
    agent_price.team_rate_for("season1", "ticket1").adult_price.should == 100
  end

end
