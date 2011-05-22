#coding: utf-8
class SpotReservationsController < ApplicationController
  before_filter :set_spot

  def index
    @search = @spot.reservations.search(params[:search])
    page = params[:page].to_i
    @reservations= @search.page(page)
  end

  def today
    page = params[:page].to_i
    @reservations= @spot.reservations.search_for_today(params[:search]).page(page)
  end

  def edit
    @reservation = @spot.reservations.find(params[:id])
    @reservation.child_true_ticket_number ||= @reservation.child_ticket_number
    @reservation.adult_true_ticket_number ||= @reservation.adult_ticket_number
  end

  def update
    @reservation = @spot.reservations.find(params[:id])
    if @reservation.update_attributes(params[:team_reservation] || params[:individual_reservation])
      @reservation.set_true_total_price
      @reservation.status = :checkedin
      @reservation.save
      redirect_to today_spot_reservations_url, :notice => "已入园成功."
    else
      render :action => 'edit'
    end
  end

end
