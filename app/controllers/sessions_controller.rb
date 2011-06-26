#coding: utf-8
class SessionsController < ApplicationController
  layout false

  def new_agent
  end

  def new_spot
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      login(user)
      redirect_to_target_or_default home_index_url
    else
      flash.now[:alert] = "不正确的用户名或密码."
      if (params[:from]=="agent")
        render :action => 'new_agent'
      else
        render :action => 'new_spot'
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/", :notice => "您已登出系统."
  end
end
