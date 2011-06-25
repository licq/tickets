class AllPurchaseHistoriesController < ApplicationController

  def index
    @search = PurchaseHistory
    page = params[:page].to_i
    @purchase_histories= @search.page(page)
  end

  def show
    @purchase_history = PurchaseHistory.find(params[:id])
  end

end
