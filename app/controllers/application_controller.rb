class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery

  def set_spot
    if current_user && (current_user.is_spot_user)
      @spot ||= current_user.spot
    else
      redirect_to '/'
    end
  end

  def set_agent
    if current_user && (current_user.is_agent_user)
      @agent ||= current_user.agent
    else
      redirect_to '/'
    end
  end

  def check_system_admin
    unless current_user && (current_user.is_system_user)
      redirect_to '/'
    end
  end

  def to_percentage(value)
     "%.2f" % (value * 100) + "%"
  end

end
