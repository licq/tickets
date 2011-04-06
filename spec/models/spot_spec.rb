#coding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe Spot do
  def new_spot(attributes = {})
    attributes[:code] ||= '003'
    attributes[:name] ||= 'spot'
    attributes[:description] ||= "description"
    attributes[:admin_attributes] ||= {}
    attributes[:city_ids] ||= [@beijing.id, @shanghai.id]
    attributes[:admin_attributes][:username] ||= "username"
    attributes[:admin_attributes][:name] ||= "name"
    attributes[:admin_attributes][:email] ||= "email@email.com"
    attributes[:admin_attributes][:password] ||= "password"
    attributes[:admin_attributes][:password_confirmation] ||= "password"
    Spot.new(attributes)
  end

  before(:all) do
    City.delete_all
    @beijing = City.create!(:name => "北京", :code => "001", :pinyin => "beijing")
    @shanghai = City.create!(:name => "上海", :code => "002", :pinyin => "shanghai")
  end

  before(:each) do
    User.delete_all
    Spot.delete_all
  end

  describe "validation" do
    it "should be valid" do
      new_spot.should be_valid
    end

    it "should require name" do
      new_spot(:name => "").should have(1).error_on(:name)
    end

    it "should reject spot with same name" do
      new_spot.save!
      new_spot(:code => "002").should have(1).error_on(:name)
    end
    it "should require code" do
      new_spot(:code => "").should have(1).error_on(:code)
    end

    it "should reject spot with same code" do
      new_spot.save!
      new_spot(:name => "name2").should have(1).error_on(:code)
    end
  end

  describe "admin" do
    it "should create an admin" do
      spot = new_spot
      spot.save!
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
      new_spot(:city_ids => []).should have(1).error_on(:cities)
    end
  end

  describe "name scope" do
    it "should return the correct result with name search" do
      new_spot.save!
      Spot.name_like("sp").count.should == 1
      Spot.name_like("").count.should == 1
    end
  end

#  describe "search" do
#    it "should return the correct results with search" do
#      new_spot.save!
#
#      new_spot(:city_ids => [@beijing.id],:name => "jingqu1",:code => "011", :admin_attributes => {:username => "admintest"}).save!
#      new_spot(:city_ids => [@shanghai.id],:name => "jingqu2",:code => "012",:admin_attributes => {:username => "admintest2"}).save!
#      spots = Spot.search("jingqu",nil,nil)
#      spots.size.should == 2
#    end
#  end
end
