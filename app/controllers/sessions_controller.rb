#coding: utf-8
class SessionsController < ApplicationController
  layout false

  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      login(user)
      if(user.type == "AgentOperator")
        url = new_reservation_path
      elsif(user.type == "SpotAdmin")
        url = today_spot_reservations_path
      else
        url = spots_path
      end
      redirect_to_target_or_default url, :notice => "登陆已成功."
    else
      flash.now[:alert] = "不正确的用户名或密码."
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, :notice => "您已登出系统."
  end
end
