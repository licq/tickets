#encoding: utf-8
class ReportsController < ApplicationController

  before_filter :set_spot


  def spot_output
    respond_to do |format|
      format.html
      format.js {
        generate_spot_output()
      }

      format.pdf {
        generate_spot_output()
      }
    end
  end

  def spot_output_rate
    respond_to do |format|
      format.html
      format.js {
        generate_spot_output_rate()
      }

      format.pdf {
        generate_spot_output_rate()
      }
    end
  end


  def spot_checkin
    respond_to do |format|
      format.html
      format.js {
        generate_spot_checkin()
      }

      format.pdf {
        generate_spot_checkin()
      }
    end
  end

  def spot_agent_output
    respond_to do |format|
      format.html
      format.js {
        generate_spot_agent_output()
      }

      format.pdf {
        generate_spot_agent_output()
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

  def get_start_parameters_by_rate
    year = params[:year].to_i
    month = params[:month].to_i
    start_date = DateTime.new(year, month, 1).beginning_of_month
    return start_date
  end

  def generate_spot_output
    @start_time, @end_time = get_start_and_end_parameters
    @table = @spot.reservations.exclude_canceled.sum_output_between(@start_time, @end_time)
  end

  def generate_spot_checkin
    @start_time, @end_time = get_start_and_end_parameters
    @table = @spot.reservations.exclude_canceled.sum_checkin_between(@start_time, @end_time)
  end

  def generate_spot_agent_output
    @start_time, @end_time = get_start_and_end_parameters
    @table = @spot.reservations.exclude_canceled.sum_agent_output_between(@start_time, @end_time)
  end


  def generate_spot_output_rate
    @start_time = get_start_parameters_by_rate
    @table = @spot.reservations.exclude_canceled.sum_output_between(@start_time, @start_time.end_of_month)
    @prev_month_table = @spot.reservations.exclude_canceled.sum_output_between(@start_time.prev_month, @start_time.end_of_month.prev_month)
    @prev_year_table = @spot.reservations.exclude_canceled.sum_output_between(@start_time.prev_year, @start_time.end_of_month.prev_year)
    if (@prev_month_table[0] == 0)
      @prev_month_count_rate = '-'
      @prev_month_price_rate = '-'
    else
      @prev_month_count_rate = "%.3f" % (@table[0].to_f/@prev_month_table[0])
      @prev_month_price_rate = "%.3f" % (@table[3].to_f/@prev_month_table[3])
    end

    if (@prev_year_table[0] == 0)
      @prev_year_count_rate = '-'
      @prev_year_price_rate = '-'
    else
      @prev_year_count_rate = "%.3f" % (@table[0].to_f/@prev_month_table[0])
      @prev_year_price_rate = "%.3f" % (@table[3].to_f/@prev_month_table[3])
    end

  end


end
