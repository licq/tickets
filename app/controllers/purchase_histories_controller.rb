class PurchaseHistoriesController < ApplicationController
  before_filter :set_spot

  def index
    @search = @spot.purchase_histories
    page = params[:page].to_i
    @purchase_histories= @search.page(page)
  end

  def show
    @purchase_history = @spot.purchase_histories.find(params[:id])
  end

end
