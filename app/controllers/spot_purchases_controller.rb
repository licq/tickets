class SpotPurchasesController < ApplicationController
  before_filter :set_spot

  def index
    @table = @spot.reservations.sum_purchase_with_agents
  end

end
