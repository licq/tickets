#coding: utf-8
class ReservationsController < ApplicationController

  before_filter :set_agent

  def index
    params[:date] = Date.today + 1
  end

  def search
    @date = params[:date]
    @search = AgentPrice.connected_for_agent(@agent.id).search(:spot_name_contains => params[:spot_name],
                                                               :spot_cities_name_contains => params[:city_name])
    page = params[:page].to_i
    @agent_prices= @search.page(page)
    render :action => 'index'
  end


  def create
    @reservation = @agent.reservations.new(params[:reservation])
    @reservation.type = params[:reservation][:type]
    @reservation.total_price = @reservation.calculate_price
    if @reservation.save
      redirect_to reservations_url, :notice => "已预订成功."
    else
      render :action => 'new'
    end
  end

#  def edit
#    @reservation = @agent.reservations.find(params[:id])
#  end
#
#  def update
#    @reservation = @agent.reservations.find(params[:id])
#    if @reservation.update_attributes(params[:reservation])
#      redirect_to reservations_url, :notice => "已修改成功."
#    else
#      render :action => 'edit'
#    end
#  end
#
#  def destroy
#    @reservation = @agent.reservations.find(params[:id])
#    @reservation.destroy
#    redirect_to reservations_url, :notice => "已删除成功"
#  end

  def individual
    @agent_price = AgentPrice.find(params[:agent_price])
    ticket = Ticket.find(params[:ticket])
    @reservation = IndividualReservation.new( :agent => @agent,
    :spot => @agent_price.spot, :ticket_name => ticket.name, :date => params[:date])
    price = @agent_price.price_for(params[:date])
    if (price[ticket.id].nil? || price[ticket.id][:individual_rate].nil?)
      redirect_to reservations_url, :method => :post, :notice => "未设置价格，不能预订."
    else
      individual_rate =price[ticket.id][:individual_rate]
      @reservation.child_sale_price = individual_rate.child_sale_price
      @reservation.child_purchase_price = individual_rate.child_purchase_price
      @reservation.adult_sale_price = individual_rate.adult_sale_price
      @reservation.adult_purchase_price = individual_rate.adult_purchase_price
      render :action => 'new'
    end
  end

  def team
    @reservation = @agent.reservations.build(:type => TeamReservation)
    @agent_price = AgentPrice.find(params[:agent_price])
    ticket = Ticket.find(params[:ticket])
    @reservation.spot = @agent_price.spot
    @reservation.ticket = ticket
    @reservation.date = params[:date]
    price = @agent_price.price_for(params[:date])
    if (price[ticket.id].nil? || price[ticket.id][:team_rate].nil?)
      redirect_to reservations_url, :method => :post, :notice => "未设置价格，不能预订."
    else
      team_rate =price[ticket.id][:team_rate]
      @reservation.child_price = team_rate.child_price
      @reservation.adult_price = team_rate.adult_price
      render :action => 'new'
    end
  end

end
