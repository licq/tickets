require File.dirname(__FILE__) + '/../spec_helper'

describe Ticket do
  before(:each) do
    Ticket.delete_all
    User.delete_all
    City.delete_all
    Spot.delete_all
  end

  it "should be valid" do
    Factory.build(:ticket).should be_valid
  end

  it "should require a name" do
    Factory.build(:ticket, :name =>"").should_not be_valid
  end

  it "should require a unique name" do
    Factory(:ticket, :name =>"notuniquename")
    Factory.build(:ticket, :name =>"notuniquename").should have(1).error_on(:name)
  end

  it "should return the rate for the season" do
    season1 = Factory.build(:season, :name => "season1")
    season2 = Factory.build(:season, :name => "season2")
    rate1 = PublicRate.new(:adult_price => 100, :child_price => 40, :season => season1)
    rate2 = PublicRate.new(:adult_price => 55, :child_price => 20, :season => season2)
    ticket = Factory.build(:ticket, :public_rates => [rate1, rate2])
    ticket.public_rate_for("season1").adult_price.should == 100
  end
end

# == Schema Information
#
# Table name: tickets
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  spot_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

