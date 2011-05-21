require File.dirname(__FILE__) + '/../spec_helper'

describe ReservationsController do

  before(:each) do
    Spot.delete_all
    User.delete_all
    City.delete_all
    Season.delete_all
    Ticket.delete_all
    AgentPrice.delete_all
    Agent.delete_all
    Rfp.delete_all
    Reservation.delete_all
    @reservation = Factory(:reservation)
    @agent_operator = Factory(:agent_operator, :agent => @reservation.agent)
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


end
