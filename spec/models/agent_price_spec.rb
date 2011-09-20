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
    agent_price.team_rate_for(season1, ticket1).adult_price.should == 100
  end

  it "should return right individual_rate_for_date" do
    agent_price = Factory(:agent_price)
    ticket = Factory(:ticket)
    season = Factory(:season)
    date = Date.today + 1
    individual_rate = Factory(:individual_rate, {:agent_price => agent_price, :ticket => ticket,
                                                 :season => season, :child_sale_price => 50, :adult_sale_price=> 100})
    agent_price.price_for(date)[ticket.id][:individual_rate].child_sale_price.should == 50

  end

end

# == Schema Information
#
# Table name: agent_prices
#
#  id         :integer(4)      not null, primary key
#  spot_id    :integer(4)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

