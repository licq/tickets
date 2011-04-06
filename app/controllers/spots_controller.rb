#coding: utf-8
class SpotsController < ApplicationController
  def index
    @search = Spot.search(params[:search])
    @spots= @search.page(params[:page]).per(2)
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
      redirect_to @spot, :notice  => "修改已成功."
    else
      render :action => 'edit'
    end
  end
end
