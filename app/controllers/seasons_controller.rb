class SeasonsController < ApplicationController
  def index
    @seasons = Season.all
  end

  def show
    @season = Season.find(params[:id])
  end

  def new
    @season = Season.new
  end

  def create
    @season = Season.new(params[:season])
    if @season.save
      redirect_to @season, :notice => "Successfully created season."
    else
      render :action => 'new'
    end
  end

  def edit
    @season = Season.find(params[:id])
  end

  def update
    @season = Season.find(params[:id])
    if @season.update_attributes(params[:season])
      redirect_to @season, :notice  => "Successfully updated season."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @season = Season.find(params[:id])
    @season.destroy
    redirect_to seasons_url, :notice => "Successfully destroyed season."
  end
end
