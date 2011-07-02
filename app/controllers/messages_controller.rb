#encoding: utf-8
class MessagesController < ApplicationController
  before_filter :set_spot_or_agent

  def index
    @messages = @partner.received_messages.page(params[:page])
    @messages.update_all(:read => true)
  end

  def destroy
    @message = @partner.received_messages.find(params[:id])
    @message.destroy
    redirect_to messages_url, :notice => "消息已删除"
  end

  private
  def set_spot_or_agent
    if current_user && current_user.is_spot_user
      @partner = current_user.spot
    elsif current_user && current_user.is_agent_user
      @partner = current_user.agent
    else
      redirect_to '/'
    end
  end
end
