#encoding: utf-8
class ReportsController < ApplicationController

  before_filter :set_spot


  def output
    respond_to do |format|
      format.html
      format.js {
        generate_output
      }

      format.pdf {
        generate_output()
      }
    end
  end

  private
  def get_start_and_end_parameters
    year = params[:year].to_i
    month = params[:month].to_i
    day = params[:day].to_i
    week = params[:week].to_i
    case params[:type]
      when 'day'
        start_date = DateTime.new(year, month, day).beginning_of_day
        end_date = start_date.end_of_day
      when 'month'
        start_date = DateTime.new(year, month, 1).beginning_of_month
        end_date = start_date.end_of_month
      when 'week'
        start_date = DateTime.commercial(year, week, 1).beginning_of_day
        end_date = DateTime.commercial(year, week, 7).end_of_day
    end
    return start_date, end_date
  end

  def generate_output
    @start_time, @end_time = get_start_and_end_parameters
    @table = @spot.reservations.exclude_canceled.sum_between(@start_time, @end_time)
  end


end
