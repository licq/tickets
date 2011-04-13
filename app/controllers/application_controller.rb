class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery

  def set_spot
     if current_user && (current_user.type = "SpotAdmin")
       @spot ||= current_user.spot
     else
       redirect_to login_url
     end
   end

end
