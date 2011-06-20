#encoding: utf-8
class AgentRolesController < ApplicationController
  before_filter :set_agent
  before_filter :set_menus_url

  def index
    @roles = @agent.roles
  end

  def new
    @role = @agent.roles.new
  end

  def create
    @role =@agent.roles.new(params[:role])
    if @role.save
      redirect_to agent_roles_path, :notice => "新建已成功"
    else
      flash.now[:error] = "至少选择一个菜单" if @role.menus.empty?
      render :action => 'new'
    end
  end

  def edit
    @role =@agent.roles.find(params[:id])
  end

  def update
    @role =@agent.roles.find(params[:id])
    if @role.update_attributes(params[:role])
      redirect_to agent_roles_path, :notice => "修改已成功"
    else
      render :action => 'edit'
    end
  end

  def menu_groups
    respond_to do |format|
      format.js do
        @menu_groups = MenuGroup.for_agent
      end
    end
  end

  def destroy
    @role = @agent.roles.find(params[:id])
    if (@role.users.empty?)
      @role.destroy
      redirect_to agent_roles_path, :notice => "角色已删除成功"
    else
      redirect_to agent_roles_path, :error => "角色还有用户关联，不能删除"
    end
  end

  private
  def set_menus_url
    @menus_url = '/agent_roles/menu_groups.js'
  end

end
