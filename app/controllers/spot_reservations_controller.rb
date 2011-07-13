#coding: utf-8
class SpotReservationsController < ApplicationController
  before_filter :set_spot

  def index
    @search = @spot.reservations.includes(:agent).search(params[:search])
    page = params[:page].to_i
    @reservations= @search.page(page)
  end

  def today
    page = params[:page].to_i
    @reservations= @spot.reservations.includes(:agent).search_for_today(params[:search]).page(page)
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
    if @reservation.update_attributes(params[:team_reservation] || params[:individual_reservation])
      if @reservation.adult_true_ticket_number.blank? || @reservation.adult_true_ticket_number == 0
        @reservation.errors.add(:adult_true_ticket_number,"实到城人数必须大于0")
        render :edit
        return
      end
      @reservation.set_true_total_price
      @reservation.date = Date.today
      @reservation.status = :checkedin
      if (@reservation.type == 'TeamReservation' && @reservation.payment_method == 'poa')
        @reservation.paid = true
      else
        @reservation.paid = false
      end
      @reservation.save!
      redirect_to today_spot_reservations_url, :notice => "已入园成功."
    else
      render :action => 'edit'
    end
  end

end
