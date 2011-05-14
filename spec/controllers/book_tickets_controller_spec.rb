require File.dirname(__FILE__) + '/../spec_helper'

describe BookTicketsController do

  before(:each) do
    Spot.delete_all
    User.delete_all
    City.delete_all
    Season.delete_all
    Ticket.delete_all
    AgentPrice.delete_all
    Agent.delete_all
    Rfp.delete_all
    @book_ticket = Factory(:book_ticket)
    @agent_operator = Factory(:agent_operator, :agent => @book_ticket.agent)
    test_login(@agent_operator)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

#  it "create action should redirect when model is valid" do
#    post 'create', :book_ticket => @book_ticket
#    response.should be_success
#  end

end
