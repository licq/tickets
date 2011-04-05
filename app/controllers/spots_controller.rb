class SpotsController < ApplicationController
  def index
    search = Spot.scoped
    if params[:search]
      search = search.name_with(params[:search][:name])
      if params[:search][:disabled] == "true"
         search = search.status(true)
      else
         search = search.status(false)
      end

    end
    @spots= search.page(params[:page]).per(2)
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
      redirect_to @spot, :notice => "Successfully created spot."
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
      redirect_to @spot, :notice  => "Successfully updated spot."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy
    redirect_to spots_url, :notice => "Successfully destroyed spot."
  end
end
