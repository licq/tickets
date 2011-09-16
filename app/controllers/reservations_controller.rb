#coding: utf-8
class ReservationsController < ApplicationController

  before_filter :set_agent
  layout 'application', :except => [:print]

  def index
    @search = @agent.reservations.includes(:spot).search(prepare_index_condition)
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
    @row_span_size = current_user.is_spot_price_all ? 1 : 2
    render :action => 'new'
  end


  def edit
    @reservation = @agent.reservations.find(params[:id])
    no_price = false
    if params[:date]
      if @reservation.is_individual?
        individual_rate = AgentPrice.individual_price(@reservation.spot_id, @reservation.agent_id, params[:date])
        if individual_rate
          if @reservation.child_ticket_number > 0 && (individual_rate.child_purchase_price.nil? || individual_rate.child_sale_price.nil?)
            no_price = true
          else
            @reservation.date = params[:date]
            @reservation.child_sale_price = individual_rate.child_sale_price
            @reservation.child_purchase_price = individual_rate.child_purchase_price
            @reservation.adult_sale_price = individual_rate.adult_sale_price
            @reservation.adult_purchase_price = individual_rate.adult_purchase_price
            @reservation.book_price =@reservation.calculate_price
            @reservation.book_purchase_price =@reservation.calculate_purchase_price
            @reservation.total_price =@reservation.book_price
            @reservation.total_purchase_price =@reservation.book_purchase_price
          end
        else
          no_price = true
        end
      else
        team_rate = AgentPrice.team_price(@reservation.spot_id, @reservation.agent_id, params[:date])
        if team_rate
          if @reservation.child_ticket_number > 0 && (team_rate.child_price.nil?)
            no_price = true
          else
            @reservation.date = params[:date]
            @reservation.child_price = team_rate.child_price
            @reservation.adult_price = team_rate.adult_price
            @reservation.book_price =@reservation.calculate_price
            @reservation.total_price =@reservation.book_price
          end
        else
          no_price = true
        end
      end
    end

    if no_price
      flash.now[:notice] = "该日" + params[:date] + "没有价格"
    end
  end

  def show
    @reservation = @agent.reservations.find(params[:id])
  end

  def create_individual
    @reservation = IndividualReservation.new(params[:individual_reservation])
    @reservation.agent = @agent
    @reservation.paid = false
    @reservation.settled = false
    @reservation.status = :confirmed
    @reservation.book_price =@reservation.calculate_price
    @reservation.book_purchase_price =@reservation.calculate_purchase_price
    @reservation.total_price =@reservation.book_price
    @reservation.total_purchase_price =@reservation.book_purchase_price
    @reservation.user = current_user
    set_verified(@reservation)

    if @reservation.save
      if @reservation.need_pay?
        redirect_to pay_alipay_path(@reservation)
      else
        redirect_to reservations_url, :notice => "已预订成功."
      end
    else
      render :action => 'new_individual'
    end
  end

  def create_team
    @reservation = TeamReservation.new(params[:team_reservation])
    @reservation.agent = @agent
    @reservation.paid = false
    @reservation.settled= false
    @reservation.status = :confirmed
    @reservation.book_price =@reservation.calculate_price
    @reservation.total_price =@reservation.book_price
    @reservation.user = current_user
    set_verified(@reservation)

    if @reservation.save
      if @reservation.need_pay?
        redirect_to pay_alipay_path(@reservation)
      else
        redirect_to reservations_url, :notice => "已预订成功."
      end
    else
      render :action => 'new_team'
    end
  end


  def update_individual
    @reservation = @agent.reservations.find(params[:id])
    @reservation.user = current_user
    if @reservation.update_attributes(params[:individual_reservation])
      @reservation.save_total_price
      redirect_to reservations_url, :notice => "已修改成功."
    else
      render :action => 'edit'
    end
  end

  def update_team
    @reservation = @agent.reservations.find(params[:id])
    @reservation.user = current_user
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
                                             :payment_method => params[:payment_method])
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
                                       :payment_method => params[:payment_method])
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

  def print
    @reservation = @agent.reservations.find(params[:id])
  end

  def used_contacts
    respond_to do |format|
      ActiveRecord::Base.include_root_in_json = false
      format.json { render :text => @agent.reservations.used_contacts(params[:search]).to_json }
    end
  end

  def unverified
    @search = @agent.reservations.search(prepare_unverified_condition)
    @reservations = @search.all
  end


  def verify
    @reservation = @agent.reservations.find(params[:id])
    @reservation.verified = true
    @reservation.save!
    redirect_to unverified_reservations_path
  end


  private
  def set_verified(reservation)
    if reservation.payment_method == "poa"
      reservation.verified = true
    else
      reservation.verified = false
    end
  end

  def prepare_index_condition
    condition = params[:search]
    if condition
      if condition[:status_eq] == "confirmed"
        condition[:date_lte] = Date.today
      elsif condition[:status_eq] == "outdated"
        condition[:status_eq] = "confirmed"
        condition[:date_gt] = Date.today
      end
    else
      condition = {}
    end
    prepare_reservation_type_condition(condition)
  end

  def prepare_unverified_condition
    conditions = params[:search]
    if conditions.nil?
      conditions = {}
    end
    conditions[:verified_eq] = false
    conditions[:payment_method_eq] = "prepay"
    prepare_reservation_type_condition(conditions)
  end

  def prepare_reservation_type_condition(condition)
    if current_user.is_spot_price_all != true
      if current_user.has_spot_team_price
        condition[:type_eq] = "TeamReservation"
      end

      if current_user.has_spot_individual_price
        condition[:type_eq] = "IndividualReservation"
      end
    end
    condition
  end

end
