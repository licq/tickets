class AgentSpotsController < ApplicationController

  before_filter :set_agent
  def index
    @search = Spot.not_connected_with_agent(@agent).search(params[:search])
    page = params[:page].to_i
    @spots= @search.page(page)
    if (@spots.all.empty?) && (page > 1)
      @spots = @search.page(page -1)
    end
  end

  def show
    @spot = Spot.find(params[:id])
  end

end
