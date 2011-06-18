class AgentPurchasesController < ApplicationController
  before_filter :set_agent

  def index
    @spot_name = params[:spot_name]
    @date = params[:date]
    condition = {}
    if @spot_name.present?
      condition[:spot] = {:name.matches => "%#{@spot_name}%"}
    end
    if @date.present?
      condition[:date.lte] = @date
    end
    @table = @agent.reservations.joins(:spot).where(condition).sum_purchase_with_spots
  end

  def reservations
    @date = params[:date]
    @spot_name = params[:spot_name]
    @spot = Spot.find(params[:spot_id])
    @reservations = @agent.reservations.where(:spot_id => params[:spot_id], :payment_method => params[:payment_method], :type => params[:type], :paid => false, :status => "checkedin")
    if @date.present?
      @reservations = @reservations.where(:date.lte => @date)
    end
    @reservations
  end

  def update_paid
    @agent.reservations.where(:payment_method => "poa").update_all(["paid=?", true], :id => params[:reservation_ids])
    redirect_to agent_purchases_path({:date =>params[:date], :spot_name =>params[:spot_name]})
  end


end
