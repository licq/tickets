#encoding: utf-8
class RolesController < ApplicationController
  before_filter :set_spot
  before_filter :set_menus_url


  def index
    @roles = @spot.roles
  end

  def new
    @role = @spot.roles.new
  end

  def create
    @role =@spot.roles.new(params[:role])
    if @role.save
      redirect_to roles_path, :notice => "新建已成功"
    else
      flash.now[:error] = "至少选择一个菜单" if @role.menus.empty?
      render :action => 'new'
    end
  end

  def edit
    @menus_url = '/roles/menu_groups.js'
    @role =@spot.roles.find(params[:id])
  end

  def update
    @role =@spot.roles.find(params[:id])
    if @role.update_attributes(params[:role])
      redirect_to roles_path, :notice => "修改已成功"
    else
      render :action => 'edit'
    end
  end

  def menu_groups
    respond_to do |format|
      format.js do
        @menu_groups = MenuGroup.for_spot
      end
    end
  end

  def destroy
    @role = @spot.roles.find(params[:id])
    if (@role.users.empty?)
      @role.destroy
      redirect_to roles_path, :notice => "角色已删除成功"
    else
      redirect_to roles_path, :error => "角色还有用户关联，不能删除"
    end

  end

  private
  def set_menus_url
    @menus_url = '/roles/menu_groups.js'
  end

end