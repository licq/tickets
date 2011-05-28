class SpotAgentsController < ApplicationController

  before_filter :set_spot

  def index
    @search = Agent.not_connected_with_spot(@spot).search(params[:search])
    page = params[:page].to_i
    @agents= @search.page(page)
    if (@agents.all.empty?) && (page > 1)
      @agents = @search.page(page -1)
    end
  end

  def show
    @agent = Agent.find(params[:id])
  end

end
