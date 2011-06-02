class AllRfpsController < ApplicationController

  before_filter :check_system_admin

  def index
    @search = Rfp.includes(:spot,:agent,:agent_price).search(params[:search])
    page = params[:page].to_i
    @rfps= @search.page(page)
  end

end
