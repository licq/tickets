#encoding: utf-8
class AgentUsersController < ApplicationController
  before_filter :set_agent

  def index
    @search = @agent.operators.where(:deleted => false).search(params[:search])
    page = params[:page].to_i
    @users= @search.page(page)
  end

  def show
    @user =@agent.operators.find(params[:id])
  end

  def new
    @user =@agent.operators.new
  end

  def create
    @user =@agent.operators.new(params[:agent_operator])
    if @user.save
      redirect_to agent_users_path, :notice => "新建已成功"
    else
      render :action => 'new'
    end
  end

  def edit
    @user =@agent.operators.find(params[:id])
  end

  def update
    @user =@agent.operators.find(params[:id])
    if @user.update_attributes(params[:agent_operator])
      redirect_to agent_users_path, :notice => "修改已成功"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = @agent.operators.find(params[:id])
    @user.deleted = true
    @user.save
    redirect_to agent_users_path, :notice => "删除已成功."
  end

end
