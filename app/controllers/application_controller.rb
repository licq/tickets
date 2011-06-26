class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery

  def set_spot
    if current_user && (current_user.type = "SpotAdmin" || current_user.type = "SpotOperator")
      @spot ||= current_user.spot
    else
      redirect_to new_spot_url
    end
  end

  def set_agent
    if current_user && (current_user.type = "AgentOperator")
      @agent ||= current_user.agent
    else
      redirect_to new_agent_url
    end
  end

  def check_system_admin
    unless current_user && (current_user.type == "SystemAdmin")
      redirect_to new_spot_url
    end
  end

  def to_percentage(value)
     "%.2f" % (value * 100) + "%"
  end

end
