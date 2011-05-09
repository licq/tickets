require File.dirname(__FILE__) + '/../spec_helper'

describe BookTicket do
  before(:each) do
    Ticket.delete_all
    User.delete_all
    City.delete_all
    Spot.delete_all
    Season.delete_all
    Agent.delete_all
    AgentPrice.delete_all
    Rfp.delete_all
    IndividualRate.delete_all
  end

  it "should be valid" do
    Factory.build(:book_ticket).should be_valid
  end
end
