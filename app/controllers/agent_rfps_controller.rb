#coding: utf-8
class AgentRfpsController < ApplicationController

  before_filter :set_agent

  def index
    @search = @agent.rfps.connected.search(params[:search])
    page = params[:page].to_i
    @rfps= @search.page(page)
    if (@rfps.all.empty?) && (page > 1)
      @rfps = @search.page(page -1)
    end
  end


  def create
    respond_to do |format|
      format.js do
        Rfp.delete_by_spot_id_and_agent_id(params[:spot_id], @agent.id)
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
    @rfp = @agent.rfps.where(:spot_id => params[:id], :status => 'a').first
    @rfp.destroy
    redirect_to applied_agent_spots_path, :notice => "撤销已成功"
  end


end
