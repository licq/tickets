require File.dirname(__FILE__) + '/../spec_helper'

describe AgentPricesController do

  before(:each) do
    Spot.delete_all
    User.delete_all
    City.delete_all
    Season.delete_all
    Ticket.delete_all
    @season = Factory(:season)
    @spot_admin = Factory(:spot_admin, :spot => @season.spot)
    @ticket = Factory(:ticket, :spot_id => @season.spot.id)
    test_login(@spot_admin)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end


  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    AgentPrice.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    AgentPrice.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(agent_price_url(assigns[:agent_price]))
  end

  it "edit action should render edit template" do
    get :edit, :id => AgentPrice.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    AgentPrice.any_instance.stubs(:valid?).returns(false)
    put :update, :id => AgentPrice.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    AgentPrice.any_instance.stubs(:valid?).returns(true)
    put :update, :id => AgentPrice.first
    response.should redirect_to(agent_price_url(assigns[:agent_price]))
  end

  it "destroy action should destroy model and redirect to index action" do
    agent_price = AgentPrice.first
    delete :destroy, :id => agent_price
    response.should redirect_to(agent_prices_url)
    AgentPrice.exists?(agent_price.id).should be_false
  end
end
