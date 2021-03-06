class AllReservationsController < ApplicationController

  before_filter :check_system_admin

  def index
    @search = Reservation.includes(:spot,:agent).search(params[:search])
    page = params[:page].to_i
    @reservations= @search.page(page)
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

end
