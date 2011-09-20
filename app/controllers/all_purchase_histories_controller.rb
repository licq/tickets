class AllPurchaseHistoriesController < ApplicationController
  before_filter :check_system_admin

  def index
    @search = PurchaseHistory
    page = params[:page].to_i
    @purchase_histories= @search.page(page)
  end

  def show
    @purchase_history = PurchaseHistory.find(params[:id])
  end

end
