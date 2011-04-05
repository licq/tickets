class CitiesController < ApplicationController
  def index
    @cities = City.search(params[:q])
    respond_to do |format|
      format.html
      format.json {render :json => @cities.map(&:attributes)}
    end
  end
end
