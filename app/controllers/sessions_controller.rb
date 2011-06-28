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
      url = home_index_url
      if user.is_spot_user && (user.type == "SpotAdmin" || user.role.menus.exists?(:url => "today_spot_reservations_path"))
        url = eval("today_spot_reservations_path")
      elsif user.is_agent_user && (user.type == "AgentAdmin" || user.role.menus.exists?(:url => "new_reservation_path"))
        url = eval("new_reservation_path")
      end
      redirect_to_target_or_default url
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
    redirect_to "/"
  end
end
