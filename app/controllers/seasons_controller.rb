#coding=utf-8
class SeasonsController < ApplicationController
  before_filter :set_spot

  def index
    @seasons = @spot.seasons.all
  end

  def new
    @season = @spot.seasons.build
    @season.timespans.build
  end

  def create
    @season = @spot.seasons.build(params[:season])
    if @season.save
      redirect_to seasons_path, :notice => "创建已成功."
    else
      render :action => 'new'
    end
  end

  def edit
    @season = @spot.seasons.find(params[:id])
  end

  def update
    @season = @spot.seasons.find(params[:id])
    begin
      if @season.update_attributes(params[:season]) && @season.reload.valid?
        redirect_to seasons_path, :notice => "修改已成功."
      else
        render :action => 'edit'
      end
    rescue
      render :action => 'edit'
    end
  end

  def destroy
    @season = @spot.seasons.find(params[:id])
    @season.destroy
    redirect_to seasons_url, :notice => "删除已成功."
  end

  private
  def set_spot
    if logged_in? && (current_user.type = "SpotAdmin")
      @spot ||= current_user.spot
    else
      redirect_to login_url
    end
  end
end
