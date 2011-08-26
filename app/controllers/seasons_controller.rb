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
    error_happened = false
    Season.transaction do
      if @season.save
        timespans = @spot.timespans
        overlaped_timespans = Timespan.has_overlap(timespans)
        if (overlaped_timespans)
          error_happened = true
          flash.now[:error] = "时间段#{overlaped_timespans[0]}与#{overlaped_timespans[1]}冲突"
          raise ActiveRecord::Rollback
        end
      else
        error_happened = true
      end
    end
    if error_happened
      render :action => 'new'
    else
      redirect_to seasons_path, :notice => "创建已成功."
    end
  end

  def edit
    @season = @spot.seasons.find(params[:id])
  end

  def update
    @season = @spot.seasons.find(params[:id])
    error_happened = false
    Season.transaction do
      if @season.update_attributes(params[:season]) && @season.reload.valid?
        timespans = @spot.timespans
        overlaped_timespans = Timespan.has_overlap(timespans)
        if (overlaped_timespans)
          error_happened = true
          flash.now[:error] = "时间段#{overlaped_timespans[0]}与#{overlaped_timespans[1]}冲突"
          raise ActiveRecord::Rollback
        end
      end
    end
    if error_happened
      render :action => 'edit'
    else
      redirect_to seasons_path, :notice => "修改已成功."
    end
  end


  def destroy
    @season = @spot.seasons.find(params[:id])
    @season.destroy
    redirect_to seasons_url, :notice => "删除已成功."
  end

end
