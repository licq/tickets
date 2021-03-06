require File.dirname(__FILE__) + '/../spec_helper'

describe RfpsController do

  before(:each) do
    Spot.delete_all
    User.delete_all
    City.delete_all
    Season.delete_all
    Ticket.delete_all
    AgentPrice.delete_all
    Agent.delete_all
    Rfp.delete_all
    @rfp = Factory(:rfp)
    @spot_admin = Factory(:spot_admin, :spot => @rfp.spot)
    test_login(@spot_admin)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Rfp.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Rfp.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Rfp.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(rfps_url)
  end

  it "edit action should render edit template" do
    get :edit, :id => Rfp.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Rfp.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Rfp.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Rfp.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Rfp.first
    response.should redirect_to(rfps_url)
  end

  it "destroy action should destroy model and redirect to index action" do
    rfp = Rfp.first
    delete :destroy, :id => rfp
    response.should redirect_to(rfps_url)
    Rfp.exists?(rfp.id).should be_false
  end
end
