#coding: utf-8
require 'spec_helper'

describe City do
  before(:each) do
    City.delete_all
    City.create!(:name => "北京", :code => "001", :pinyin => "beijing")
    City.create!(:name => "上海", :code => "002", :pinyin => "shanghai")
    City.create!(:name => "泰山", :code => "003", :pinyin => "taishan")
    City.create!(:name => "南京", :code => "004", :pinyin => "nanjing")
  end
  it "should return search results with pinyin" do
    cities = City.search("sh")
    cities.size.should == 1
    cities[0].code.should == "002"
  end
  it "should return search results with name" do
    cities = City.search("上")
    cities.size.should == 1
    cities[0].code.should == "002"
  end


end
