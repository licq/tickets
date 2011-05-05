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

  it "should return right total price" do
    book_ticket = Factory.build(:book_ticket)
    agent_price = Factory(:agent_price)
    timespans = Factory(:timespan, :season_id => 1)
    rfp = Factory(:rfp, {:agent_price => agent_price, :spot => book_ticket.spot, :agent => book_ticket.agent})
    individual_rate = Factory(:individual_rate, {:agent_price => agent_price, :ticket => book_ticket.ticket,
                                                 :season_id => 1, :child_sale_price => 50, :adult_sale_price=> 100})

    BookTicket.count_individual_total_price(book_ticket).should == 150
  end

end
