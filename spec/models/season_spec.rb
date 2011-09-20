require File.dirname(__FILE__) + '/../spec_helper'

describe Season do

  before(:each) do
    Spot.delete_all
    User.delete_all
    City.delete_all
    Season.delete_all
  end
  it "should be valid" do
    Factory.build(:season).should be_valid
  end

  it "should have a name" do
    Factory.build(:season, :name => "").should have(1).error_on(:name)
  end

  it "should validate name be unique within one spot" do
    season = Factory(:season, :name => "unique_season")
    Factory.build(:season, :name => "unique_season", :spot => season.spot).should have(1).error_on(:name)
  end

  it "should accept same name with different spot" do
    Factory(:season, :name => "unique_season")
    Factory.build(:season, :name => "unique_season").should be_valid
  end

  it "should require a timespan with one season" do
    Factory.build(:season, :timespans => []).should have(1).error_on(:timespans)
  end


end

# == Schema Information
#
# Table name: seasons
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  spot_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

