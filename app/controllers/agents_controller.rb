#coding: utf-8
class AgentsController < ApplicationController
  def index
    @search = Agent.search(params[:search] || {:disabled_eq => false})
    page = params[:page].to_i
    @agents= @search.page(page)
    if (@agents.all.empty?) && (page > 1)
      @agents = @search.page(page -1)
    end
  end

  def show
    @agent = Agent.find(params[:id])
  end

  def new
    @agent = Agent.new
    @agent.operator = AgentOperator.new
  end

  def create
    @agent = Agent.new(params[:agent])
    if @agent.save
      if (current_user.nil?)
        login(@agent.operator)
        redirect_to new_reservation_path, :notice => "感谢您注册，现在您已登陆"
      else
        redirect_to @agent, :notice => "旅行社已创建."
      end
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
      redirect_to @agent, :notice => "修改已成功"
    else
      render :action => 'edit'
    end
  end

  def disable
    respond_to do |format|
      format.js do
        @agent = Agent.find(params[:id])
        @agent.disabled = true
        @agent.save
        flash[:notice] = "禁用#{@agent.name}已成功"
      end
    end
  end

  def enable
    respond_to do |format|
      format.js do
        @agent = Agent.find(params[:id])
        @agent.disabled = false
        @agent.save
        flash[:notice] = "启用#{@agent.name}已成功"
      end
    end
  end
end
