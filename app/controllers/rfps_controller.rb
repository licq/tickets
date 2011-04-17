class RfpsController < ApplicationController
  def index
    @rfps = Rfp.all
  end

  def show
    @rfp = Rfp.find(params[:id])
  end

  def new
    @rfp = Rfp.new
  end

  def create
    @rfp = Rfp.new(params[:rfp])
    if @rfp.save
      redirect_to @rfp, :notice => "Successfully created rfp."
    else
      render :action => 'new'
    end
  end

  def edit
    @rfp = Rfp.find(params[:id])
  end

  def update
    @rfp = Rfp.find(params[:id])
    if @rfp.update_attributes(params[:rfp])
      redirect_to @rfp, :notice  => "Successfully updated rfp."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @rfp = Rfp.find(params[:id])
    @rfp.destroy
    redirect_to rfps_url, :notice => "Successfully destroyed rfp."
  end
end
