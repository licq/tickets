#coding: utf-8
class AgentRfpsController < ApplicationController

  before_filter :set_agent

  def index
    @rfps = @agent.rfps
  end

  def new
    @rfp = Rfp.new
  end

  def edit
  end

  def create
    @rfp = @agent.rfps.new(params[:rfp])
    if @rfp.save
      redirect_to agent_rfps_path, :notice => "创建已成功"
    else
      render :action => 'new'
    end
  end

  def update
  end

  def destroy
    @rfp = Rfp.find(params[:id])
    @rfp.destroy
    redirect_to agent_rfps_path, :notice => "撤销已成功"
  end

  def accept
    @rfp = Rfp.find(params[:id])
    @rfp.status = 'c'
    @rfp.save
    redirect_to agent_rfps_path, :notice => "接受已成功"
  end

  def reject
    @rfp = Rfp.find(params[:id])
    @rfp.status = 'r'
    @rfp.save
    redirect_to agent_rfps_path, :notice => "拒绝已成功"
  end

end
