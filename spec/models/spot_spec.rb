require File.dirname(__FILE__) + '/../spec_helper'

describe Spot do
  def new_spot(attributes = {})
    attributes[:code] ||= '003'
    attributes[:name] ||= 'spot'
    attributes[:description] ||= "description"
    attributes[:administrator_attributes] ||= {}
    attributes[:administrator_attributes][:username] = "username"
    attributes[:administrator_attributes][:name] = "name"
    attributes[:administrator_attributes][:email] = "email@email.com"
    attributes[:administrator_attributes][:password] = "password"
    attributes[:administrator_attributes][:password_confirmation] = "password"
    Spot.new(attributes)
  end

  before(:each) do
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

  describe "administrator" do
    it "should create an administrator" do
      spot = new_spot
      spot.save!
      spot.administrator.should_not be_nil
    end
  end
end
