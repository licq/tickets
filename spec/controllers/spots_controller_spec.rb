require File.dirname(__FILE__) + '/../spec_helper'

describe SpotsController do
  render_views

  before(:all) do
    User.delete_all
    Spot.delete_all
    City.delete_all
    @spot = Factory(:spot)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => @spot
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Spot.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Spot.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(spot_url(assigns[:spot]))
  end

  it "edit action should render edit template" do
    get :edit, :id => @spot
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Spot.any_instance.stubs(:valid?).returns(false)
    put :update, :id => @spot
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Spot.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @spot
    response.should redirect_to(spot_url(assigns[:spot]))
  end
end
