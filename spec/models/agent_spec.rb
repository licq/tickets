require File.dirname(__FILE__) + '/../spec_helper'

describe Agent do
  before(:each) do
    Agent.delete_all
    User.delete_all
  end

  it "should be valid" do
    Factory.build(:agent).should be_valid
  end

  it "should require a name" do
    Factory.build(:agent, :name=> "").should have(1).error_on(:name)
  end

  it "should reject if name exists" do
    Factory(:agent,:name => "uniquename")
    Factory.build(:agent,:name => "uniquename").should have(1).error_on(:name)
  end

  it "should require an agent_operator" do
    Factory.build(:agent, :operator => nil).should have(1).error_on(:operator)
  end
end
