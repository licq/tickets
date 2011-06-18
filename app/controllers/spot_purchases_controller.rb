class SpotPurchasesController < ApplicationController
  before_filter :set_spot

  def index
    @agent_name = params[:agent_name]
    @date = params[:date]
    condition = {}
    if @agent_name.present?
      condition[:agent] = {:name.matches => "%#{@agent_name}%"}
    end
    if @date.present?
      condition[:date.lte] = @date
    end
    @table = @spot.reservations.joins(:agent).where(condition).sum_purchase_with_agents
  end

  def reservations
    @date = params[:date]
    @agent_name = params[:agent_name]
    @agent = Agent.find(params[:agent_id])
    @reservations = @spot.reservations.where(:agent_id => params[:agent_id], :payment_method => params[:payment_method], :type => params[:type], :paid => false, :status => "checkedin")
    if @date.present?
      @reservations = @reservations.where(:date.lte => @date)
    end
    @reservations
  end

  def update_paid
    @spot.reservations.where(:payment_method => "prepay").update_all(["paid=?", true], :id => params[:reservation_ids])
    redirect_to spot_purchases_path({:date =>params[:date], :agent_name =>params[:agent_name]})
  end

end
