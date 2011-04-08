class AgentsController < ApplicationController
  def index
    @agents = Agent.all
  end

  def show
    @agent = Agent.find(params[:id])
  end

  def new
    @agent = Agent.new
  end

  def create
    @agent = Agent.new(params[:agent])
    if @agent.save
      redirect_to @agent, :notice => "Successfully created agent."
    else
      render :action => 'new'
    end
  end

  def edit
    @agent = Agent.find(params[:id])
  end

  def update
    @agent = Agent.find(params[:id])
    if @agent.update_attributes(params[:agent])
      redirect_to @agent, :notice  => "Successfully updated agent."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @agent = Agent.find(params[:id])
    @agent.destroy
    redirect_to agents_url, :notice => "Successfully destroyed agent."
  end
end
