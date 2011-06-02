#encoding: utf-8
class UsersController < ApplicationController
  before_filter :login_required
  before_filter :set_spot, :except => [:edit_myself, :update_myself]

  def index
    @search = @spot.operators.search(params[:search])
    page = params[:page].to_i
    @users= @search.page(page)
  end

  def show
    @user =@spot.operators.find(params[:id])
  end

  def new
    @user =@spot.operators.new
  end

  def create
    @user =@spot.operators.new(params[:spot_operator])
    if @user.save
      redirect_to users_path, :notice => "新建已成功"
    else
      render :action => 'new'
    end
  end

  def edit
    @user =@spot.operators.find(params[:id])
  end

  def update
    @user =@spot.operators.find(params[:id])
    if @user.update_attributes(params[:spot_operator])
      redirect_to users_path, :notice => "修改已成功"
    else
      render :action => 'edit'
    end
  end

  def edit_myself
    @user = current_user
  end

  def update_myself
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to edit_myself_user_path, :notice => "您的个人信息更新已成功."
    else
      render :action => 'edit_myself'
    end
  end
end
