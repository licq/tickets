class SeasonsController < ApplicationController
  before_filter :set_spot

  def index
    @seasons = @spot.seasons.all
  end

  def show
    @season = @spot.seasons.find(params[:id])
  end

  def new
    @season = @spot.seasons.build
    3.times { @season.timespans.build }
  end

  def create
    @season = @spot.seasons.build(params[:season])
    if @season.save
      redirect_to seasons_path, :notice => "Successfully created season."
    else
      render :action => 'new'
    end
  end

  def edit
    @season = @spot.seasons.find(params[:id])
  end

  def update
    @season = @spot.seasons.find(params[:id])
    if @season.update_attributes(params[:season])
      redirect_to seasons_path, :notice => "Successfully updated season."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @season = @spot.seasons.find(params[:id])
    @season.destroy
    redirect_to seasons_url, :notice => "Successfully destroyed season."
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
