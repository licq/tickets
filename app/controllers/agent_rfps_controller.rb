#coding: utf-8
class AgentRfpsController < ApplicationController

  before_filter :set_agent

  def index
    @rfps = @agent.rfps
  end

  def new
    @rfp = @agent.rfps.new
  end


  def create
    respond_to do |format|
      format.js do
        @rfp = @agent.rfps.new(:spot_id => params[:spot_id], :from_spot => false, :status => "a")
        if @rfp.save
          flash[:notice] = "申请已成功"
        else
          flash[:notice] = "申请失败"
        end
      end
    end
  end

  def destroy
    @rfp = @agent.rfps.find(params[:id])
    @rfp.destroy
    redirect_to agent_rfps_path, :notice => "撤销已成功"
  end

  def accept
    @rfp = @agent.rfps.find(params[:id])
    @rfp.status = 'c'
    @rfp.save
    redirect_to agent_rfps_path, :notice => "接受已成功"
  end

  def reject
    @rfp = @agent.rfps.find(params[:id])
    @rfp.status = 'r'
    @rfp.save
    redirect_to agent_rfps_path, :notice => "拒绝已成功"
  end

end
