#coding: utf-8
require 'spec_helper'

describe City do
  before(:each) do
    City.delete_all
    Factory(:city,:name => "beijing", :pinyin => "beijing")
    @shanghai = Factory(:city, :name => "上海", :pinyin => "shanghai")
  end
  it "should return search results with pinyin" do
    cities = City.search("sh")
    cities.size.should == 1
    cities[0].name.should == "上海"
  end
  it "should return search results with name" do
    cities = City.search("上")
    cities.size.should == 1
    cities[0].code.should == @shanghai.code
  end
end

# == Schema Information
#
# Table name: cities
#
#  id         :integer(4)      not null, primary key
#  code       :string(255)
#  name       :string(255)
#  pinyin     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

