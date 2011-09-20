require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    User.delete_all
  end
  it "should be valid" do
    Factory.build(:user).should be_valid
  end

  it "should require username" do
    Factory.build(:user,:username => '').should have(1).error_on(:username)
  end

  it "should require name" do
    Factory.build(:user,:name => '').should have(1).error_on(:name)
  end

  it "should require password" do
    Factory.build(:user,:password => '').should have(1).error_on(:password)
  end

  it "should require well formed email" do
    Factory.build(:user,:email => 'foo@bar@example.com').should have(1).error_on(:email)
  end

  it "should validate uniqueness of username" do
    Factory(:user,:username => 'uniquename')
    Factory.build(:user,:username => 'uniquename').should have(1).error_on(:username)
  end

  it "should not allow odd characters in username" do
    Factory.build(:user,:username => 'odd ^&(@)').should have(1).error_on(:username)
  end

  it "should validate password is longer than 3 characters" do
    Factory.build(:user,:password => 'bad').should have(1).error_on(:password)
  end

  it "should require matching password confirmation" do
    Factory.build(:user,:password_confirmation => 'nonmatching').should have(1).error_on(:password)
  end

  it "should generate password hash and salt on create" do
    user = Factory(:user)
    user.password_hash.should_not be_nil
    user.password_salt.should_not be_nil
  end

  it "should authenticate by username" do
    user = Factory(:user,:username => 'foobar', :password => 'secret')
    User.authenticate('foobar', 'secret').should == user
  end

  it "should not authenticate bad username" do
    User.authenticate('nonexisting', 'secret').should be_nil
  end

  it "should not authenticate bad password" do
    Factory(:user,:username => 'foobar', :password => 'secret')
    User.authenticate('foobar', 'badpassword').should be_nil
  end
end

# == Schema Information
#
# Table name: users
#
#  id             :integer(4)      not null, primary key
#  username       :string(255)
#  email          :string(255)
#  password_hash  :string(255)
#  password_salt  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  name           :string(255)
#  type           :string(255)
#  spot_id        :integer(4)
#  agent_id       :integer(4)
#  role_id        :integer(4)
#  deleted        :boolean(1)      default(FALSE)
#  spot_price_cat :string(255)     default("team")
#

