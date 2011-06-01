#coding: utf-8
class ReservationsController < ApplicationController

  before_filter :set_agent

  def index
    condition = params[:search]
    if condition
      if condition[:status_eq] == "confirmed"
        condition[:date_lte] = Date.today
      elsif condition[:status_eq] == "outdated"
        condition[:status_eq] = "confirmed"
        condition[:date_gt] = Date.today
      end
    end
    @search = @agent.reservations.includes(:spot).search(condition)
    page = params[:page].to_i
    @reservations= @search.page(page)
    if (@reservations.all.empty?) && (page > 1)
      @reservations = @search.page(page -1)
    end
  end

  def new
    params[:date] = Date.today
  end

  def search
    @date = params[:date]
    @search = AgentPrice.connected_for_agent(@agent.id).search(:spot_name_contains => params[:spot_name],
                                                               :spot_cities_name_contains => params[:city_name])
    page = params[:page].to_i
    @agent_prices= @search.page(page)
    render :action => 'new'
  end


  def edit
    @reservation = @agent.reservations.find(params[:id])
  end

  def show
    @reservation = @agent.reservations.find(params[:id])
  end

  def create_individual
    @reservation = IndividualReservation.new(params[:individual_reservation])
    @reservation.agent = @agent
    @reservation.status = :confirmed
    @reservation.total_price =@reservation.calculate_price
    @reservation.total_purchase_price =@reservation.calculate_purchase_price
    if @reservation.save
      redirect_to reservations_url, :notice => "已预订成功."
    else
      render :action => 'new_individual'
    end
  end

  def create_team
    @reservation = TeamReservation.new(params[:team_reservation])
    @reservation.agent = @agent
    @reservation.status = :confirmed
    @reservation.total_price =@reservation.calculate_price
    if @reservation.save
      redirect_to reservations_url, :notice => "已预订成功."
    else
      render :action => 'create_team'
    end
  end


  def update_individual
    @reservation = @agent.reservations.find(params[:id])
    if @reservation.update_attributes(params[:individual_reservation])
      @reservation.save_total_price
      redirect_to reservations_url, :notice => "已修改成功."
    else
      render :action => 'edit'
    end
  end

  def update_team
    @reservation = @agent.reservations.find(params[:id])
    if @reservation.update_attributes(params[:team_reservation])
      @reservation.save_total_price
      redirect_to reservations_url, :notice => "已修改成功."
    else
      render :action => 'edit'
    end
  end


  def new_individual
    @agent_price = AgentPrice.find(params[:agent_price])
    ticket = Ticket.find(params[:ticket])
    @reservation = IndividualReservation.new(:agent => @agent,
                                             :spot => @agent_price.spot, :ticket_name => ticket.name, :date => params[:date],
                                             :individual_payment_method => params[:individual_payment_method])
    price = @agent_price.price_for(params[:date])
    if (price[ticket.id].nil? || price[ticket.id][:individual_rate].nil?)
      redirect_to reservations_url, :method => :post, :notice => "未设置价格，不能预订."
    else
      individual_rate =price[ticket.id][:individual_rate]
      @reservation.child_sale_price = individual_rate.child_sale_price
      @reservation.child_purchase_price = individual_rate.child_purchase_price
      @reservation.adult_sale_price = individual_rate.adult_sale_price
      @reservation.adult_purchase_price = individual_rate.adult_purchase_price
    end
  end

  def new_team
    @agent_price = AgentPrice.find(params[:agent_price])
    ticket = Ticket.find(params[:ticket])
    @reservation = TeamReservation.new(:agent => @agent,
                                       :spot => @agent_price.spot, :ticket_name => ticket.name, :date => params[:date],
                                       :team_payment_method => params[:team_payment_method])
    price = @agent_price.price_for(params[:date])
    if (price[ticket.id].nil? || price[ticket.id][:team_rate].nil?)
      redirect_to reservations_url, :method => :post, :notice => "未设置价格，不能预订."
    else
      team_rate =price[ticket.id][:team_rate]
      @reservation.child_price = team_rate.child_price
      @reservation.adult_price = team_rate.adult_price
    end
  end

  def destroy
    @reservation = @agent.reservations.find(params[:id])
    @reservation.status = :canceled
    @reservation.save
    redirect_to reservations_url, :notice => "取消已成功."
  end

end
