require 'spec_helper'

describe Timespan do

  it "should be valid" do
    Factory.build(:timespan).should be_valid
  end

  it "should validate from_date is not empty" do
    Factory.build(:timespan, :from_date =>"").should have(1).error_on(:from_date)
  end

  it "should require to_date is not empty" do
    Factory.build(:timespan, :to_date =>"").should have(1).error_on(:to_date)
  end

  it "should to_date after from_date" do
    Factory.build(:timespan, :from_date => Date.today, :to_date =>Date.today-2).should have(1).error_on(:to_date)
  end

  it "should return true if two span overlap" do
    timespan1 = Timespan.new(:from_date => "2010-5-1", :to_date => "2010-10-1")
    timespan2 = Timespan.new(:from_date => "2010-9-1", :to_date => "2010-12-1")
    timespan1.overlap(timespan2).should == true
  end

  it "should return include the overlap timespans if two span overlap" do
    timespan1 = Timespan.new(:from_date => "2010-5-1", :to_date => "2010-10-1")
    timespan2 = Timespan.new(:from_date => "2010-9-1", :to_date => "2010-9-10")
    Timespan.has_overlap([timespan1,timespan2]).should include(timespan1)
  end

  it "should return false if two span not overlap" do
    timespan1 = Timespan.new(:from_date => "2010-5-1", :to_date => "2010-10-1")
    timespan2 = Timespan.new(:from_date => "2010-11-1", :to_date => "2010-12-1")
    timespan1.overlap(timespan2).should == false
  end

  it "should return false if two span not overlap" do
    timespan1 = Timespan.new(:from_date => "2010-5-1", :to_date => "2010-10-1")
    timespan2 = Timespan.new(:from_date => "2010-11-1", :to_date => "2010-12-1")
    Timespan.has_overlap([timespan1,timespan2]).should be_nil
  end
end
