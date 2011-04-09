require 'spec_helper'

describe Timespan do

  before(:each) do
    Spot.delete_all
    User.delete_all
    City.delete_all
    Season.delete_all
  end

  it "should be valid" do
    Factory.build(:timespan).should be_valid
  end

  it "should require from is not empty" do
    Factory.build(:timespan, :from =>"").should have(1).error_on(:from)
  end

  it "should require to is not empty" do
    Factory.build(:timespan, :to =>"").should have(1).error_on(:to)
  end

  it "should to after from" do
    Factory.build(:timespan, :to =>Date.today-2).should have(1).error_on(:to)
  end

  it "should return true if two span overlap" do
    timespan1 = Timespan.new(:from => "2010-5-1", :to => "2010-10-1")
    timespan2 = Timespan.new(:from => "2010-9-1", :to => "2010-12-1")
    timespan1.overlap?(timespan2).should == true
  end

  it "should return true if two span overlap" do
    timespan1 = Timespan.new(:from => "2010-5-1", :to => "2010-10-1")
    timespan2 = Timespan.new(:from => "2010-11-1", :to => "2010-12-1")
    timespan1.overlap?(timespan2).should == false
  end

end
