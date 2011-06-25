class AgentPurchaseHistoriesController < ApplicationController
  before_filter :set_agent

  def index
    @search = @agent.purchase_histories
    page = params[:page].to_i
    @purchase_histories= @search.page(page)
  end

  def show
    @purchase_history = @agent.purchase_histories.find(params[:id])
  end

end
