#coding: utf-8
class SpotsController < ApplicationController

  before_filter :check_system_admin

  def index
    @search = Spot.search(params[:search] || {:disabled_eq => false})
    page = params[:page].to_i
    @spots= @search.page(page)
    if (@spots.all.empty?) && (page > 1)
      @spots = @search.page(page -1)
    end
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def new
    @spot = Spot.new
    @spot.admin = SpotAdmin.new
  end

  def create
    @spot = Spot.new(params[:spot])
    if @spot.save
      redirect_to @spot, :notice => "景区已创建."
    else
      render :action => 'new'
    end
  end

  def edit
    @spot = Spot.find(params[:id])
  end

  def update
    @spot = Spot.find(params[:id])
    if @spot.update_attributes(params[:spot])
      redirect_to @spot, :notice => "修改已成功."
    else
      render :action => 'edit'
    end
  end

  def disable
    respond_to do |format|
      format.js do
        @spot = Spot.find(params[:id])
        @spot.disabled = true
        @spot.save!
        flash[:notice] = "禁用#{@spot.name}已成功"
      end
    end
  end

  def enable
    respond_to do |format|
      format.js do
        @spot = Spot.find(params[:id])
        @spot.disabled = false
        @spot.save!
        flash[:notice] = "启用#{@spot.name}已成功"
      end
    end
  end
end
