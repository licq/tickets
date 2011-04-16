require File.dirname(__FILE__) + '/../spec_helper'

describe AgentsController do
  render_views

  before(:each) do
    Agent.delete_all
    User.delete_all
    @agent = Factory(:agent)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => @agent
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Agent.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Agent.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(agent_url(assigns[:agent]))
  end

  it "edit action should render edit template" do
    get :edit, :id => @agent
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Agent.any_instance.stubs(:valid?).returns(false)
    put :update, :id => @agent
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Agent.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @agent
    response.should redirect_to(agent_url(assigns[:agent]))
  end

end
