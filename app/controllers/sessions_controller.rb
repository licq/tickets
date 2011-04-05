#coding: utf-8
class SessionsController < ApplicationController
  layout false

  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to_target_or_default root_url, :notice => "登陆已成功."
    else
      flash.now[:alert] = "不正确的用户名或密码."
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "您已登出系统."
  end
end
