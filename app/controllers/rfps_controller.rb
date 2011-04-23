#coding: utf-8
class RfpsController < ApplicationController
  before_filter :set_spot

  def index
    @rfps = @spot.rfps
  end

  def new
    @rfp = Rfp.new
  end

  def create
    @rfp = @spot.rfps.new(params[:rfp])
    @rfp.from_spot = true
    if @rfp.save
      redirect_to rfps_path, :notice => "创建已成功"
    else
      render :action => 'new'
    end
  end

  def edit
    @rfp = @spot.rfps.find(params[:id])
  end

  def update
    @rfp = Rfp.find(params[:id])
    if @rfp.update_attributes(params[:rfp])
      redirect_to rfps_path, :notice  => "修改已成功"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @rfp = Rfp.find(params[:id])
    @rfp.destroy
    redirect_to rfps_url, :notice => "Successfully destroyed rfp."
  end

  def accept
    @rfp = Rfp.find(params[:id])
    @rfp.status = 'c'
    @rfp.save
    redirect_to rfps_path, :notice => "接受已成功"
  end

  def reject
    @rfp = Rfp.find(params[:id])
    @rfp.status = 'r'
    @rfp.save
    redirect_to rfps_path, :notice => "拒绝已成功"
  end

end
