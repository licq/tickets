#coding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe Spot do
  before(:each) do
    Spot.delete_all
  end

  describe "validation" do
    it "should be valid" do
      Factory.build(:spot).should be_valid
    end

    it "should require name" do
      Factory.build(:spot,:name => "").should have(1).error_on(:name)
    end

    it "should reject spot with same name" do
      spot = Factory(:spot)
      Factory.build(:spot,:name => spot.name).should have(1).error_on(:name)
    end
    it "should require code" do
      Factory.build(:spot,:code => "").should have(1).error_on(:code)
    end

    it "should reject spot with same code" do
      spot = Factory(:spot)
      Factory.build(:spot,:code => spot.code).should have(1).error_on(:code)
    end
  end

  describe "admin" do
    it "should create an admin" do
      spot = Factory(:spot)
      spot.admin.should_not be_nil
    end

    it "should require an admin to create spot" do
      spot = Spot.new(:name => "spotname", :code => "003")
      spot.should_not be_valid
      spot.should have(1).error_on(:admin)
    end
  end

  describe "cities" do
    it "should require at least one city" do
      Factory.build(:spot,:cities => []).should have(1).error_on(:cities)
    end
  end
end
