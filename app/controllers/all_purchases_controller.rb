class AllPurchasesController < ApplicationController
  before_filter :check_system_admin

  def index
    @spot_name = params[:spot_name]
    @agent_name = params[:agent_name]
    @date = params[:date]
    condition = {}
    if @spot_name.present?
      condition[:spot] = {:name.matches => "%#{@spot_name}%"}
    end
     if @agent_name.present?
      condition[:agent] = {:name.matches => "%#{@agent_name}%"}
    end
    if @date.present?
      condition[:date.lte] = @date
    end
    @table = Reservation.joins(:spot, :agent).where(condition).sum_purchase_with_all
  end

  def reservations
    @date = params[:date]
    @spot_name = params[:spot_name]
    @agent_name = params[:agent_name]
    @spot = Spot.find(params[:spot_id])
    @agent = Agent.find(params[:agent_id])
    @reservations = Reservation.where(:spot_id => params[:spot_id], :agent_id=> params[:agent_id], :payment_method => params[:payment_method], :type => params[:type], :settled => false, :status => "checkedin")
    if @date.present?
      @reservations = @reservations.where(:date.lte => @date)
    end
    @reservations
  end

end
