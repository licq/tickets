#coding: utf-8
class SpotReservationsController < ApplicationController
  before_filter :set_spot

  def index
    @search = @spot.reservations.where(:verified => true).includes(:agent).search(params[:search])
    page = params[:page].to_i
    @reservations= @search.page(page)
  end

  def today
    page = params[:page].to_i
    @reservations= @spot.reservations.where(:verified => true).includes(:agent).search_for_today(params[:search]).page(page)
  end

  def edit
    @reservation = @spot.reservations.find(params[:id])
    @reservation.child_true_ticket_number ||= @reservation.child_ticket_number
    @reservation.adult_true_ticket_number ||= @reservation.adult_ticket_number
  end

  def show
    @reservation = @spot.reservations.find(params[:id])
  end

  def update
    @reservation = @spot.reservations.find(params[:id])
    if params[:adult_true_ticket_number].present? && params[:child_true_ticket_number].present?
      if @reservation.adult_true_ticket_number < params[:adult_true_ticket_number] || @reservation.child_true_ticket_number < params[:child_true_ticket_number]
        @reservation.errors.add("成人数和儿童数不能大于以前订单上的相应数值")
        render :edit
        return
      end
    end
    if @reservation.update_attributes(params[:team_reservation] || params[:individual_reservation])
      if @reservation.adult_true_ticket_number.blank? || @reservation.adult_true_ticket_number == 0
        @reservation.errors.add(:adult_true_ticket_number, "实到成人数必须大于0")
        render :edit
        return
      end
      @reservation.set_true_total_price
      @reservation.date = Date.today
      @reservation.status = :checkedin
      @reservation.paid = true if @reservation.payment_method == 'poa'
      if (@reservation.type == 'TeamReservation' && @reservation.payment_method == 'poa')
        @reservation.settled = true
      end

      if (@reservation.payment_method == "net" && @reservation.book_purchase_price == @reservation.total_purchase_price)
        @reservation.settled = true
      else
        @reservation.settled = false
      end
      @reservation.save!
      redirect_to today_spot_reservations_url, :notice => "已入园成功."
    else
      render :action => 'edit'
    end
  end

end
