#encoding: utf-8
class ReportsController < ApplicationController

  before_filter :set_spot, :only => [:spot_output, :generate_spot_output, :spot_output_rate, :generate_spot_output_rate,
                                     :spot_checkin, :spot_agent_output, :spot_month_reservations,
                                     :generate_spot_checkin, :generate_spot_agent_output, :generate_spot_month_reservations]
  before_filter :set_agent, :only => [:agent_output, :agent_output_rate, :agent_checkin, :agent_spot_output,
                                      :generate_agent_output, :generate_agent_output_rate, :generate_agent_checkin, :generate_agent_spot_output]

  layout 'application', :except => [:generate_spot_output, :generate_spot_output_rate,
                                    :generate_spot_checkin, :generate_spot_agent_output, :generate_spot_month_reservations,
                                    :generate_agent_output, :generate_agent_output_rate, :generate_agent_checkin, :generate_agent_spot_output]

  def spot_output
  end

  def spot_month_reservations
  end

  def spot_month_output
  end


  def agent_output
  end

  def spot_output_rate
  end

  def agent_output_rate
  end


  def spot_checkin
  end

  def agent_checkin
  end

  def spot_agent_output
  end


  def agent_spot_output
  end

  def generate_spot_month_reservations
    @start_time = get_start_parameters_by_rate
    @search = params[:year]+"年"+params[:month]+"月"
    @table = @spot.reservations.exclude_canceled.where(:created_at => @start_time..@start_time.end_of_month).reorder(:agent_id).all
    @total_adult_ticket_number = @table.sum(&:adult_ticket_number)
    @total_child_ticket_number = @table.sum(&:child_ticket_number)
    @total_book_price = @table.sum(&:book_price)
    @total_book_purchase_price = @table.sum(&:book_purchase_price)
  end


  def generate_spot_month_output
    @start_time = get_start_parameters_by_rate
    @search = params[:year]+"年"+params[:month]+"月"
    @table = @spot.reservations.exclude_canceled.sum_month_output_with_agents(@start_time, @start_time.end_of_month)
  end

  def generate_spot_output
    @start_time, @end_time = get_start_and_end_parameters
    @table = @spot.reservations.exclude_canceled.sum_output_between(@start_time, @end_time)
  end


  def generate_agent_output
    @start_time, @end_time = get_start_and_end_parameters
    @table = @agent.reservations.exclude_canceled.sum_output_between(@start_time, @end_time)
  end

  def generate_spot_checkin
    @start_time, @end_time = get_start_and_end_parameters
    @table = @spot.reservations.exclude_canceled.sum_checkin_between(@start_time, @end_time)
  end

  def generate_agent_checkin
    @start_time, @end_time = get_start_and_end_parameters
    @table = @agent.reservations.exclude_canceled.sum_checkin_between(@start_time, @end_time)
  end

  def generate_spot_agent_output
    @start_time, @end_time = get_start_and_end_parameters
    @table = @spot.reservations.exclude_canceled.sum_agent_output_between(@start_time, @end_time)
  end

  def generate_agent_spot_output
    @start_time, @end_time = get_start_and_end_parameters
    @table = @agent.reservations.exclude_canceled.sum_spot_output_between(@start_time, @end_time)
  end

  def generate_agent_output_rate
    @start_time = get_start_parameters_by_rate
    @table = @agent.reservations.exclude_canceled.sum_output_between(@start_time, @start_time.end_of_month)
    @prev_month_table = @agent.reservations.exclude_canceled.sum_output_between(@start_time.prev_month, @start_time.end_of_month.prev_month)
    @prev_year_table = @agent.reservations.exclude_canceled.sum_output_between(@start_time.prev_year, @start_time.end_of_month.prev_year)
    calculate_rate(@table, @prev_month_table, @prev_year_table)
  end

  def generate_spot_output_rate
    @start_time = get_start_parameters_by_rate
    @table = @spot.reservations.exclude_canceled.sum_output_between(@start_time, @start_time.end_of_month)
    @prev_month_table = @spot.reservations.exclude_canceled.sum_output_between(@start_time.prev_month, @start_time.end_of_month.prev_month)
    @prev_year_table = @spot.reservations.exclude_canceled.sum_output_between(@start_time.prev_year, @start_time.end_of_month.prev_year)
    calculate_rate(@table, @prev_month_table, @prev_year_table)
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
    DateTime.new(year, month, 1).beginning_of_month
  end

  def calculate_rate(table, prev_month_table, prev_year_table)
    if (prev_month_table.count_sum == 0)
      @prev_month_count_rate = '-'
      @prev_month_price_rate = '-'
    else
      @prev_month_count_rate = to_percentage(table.count_sum.to_f/prev_month_table.count_sum)
      @prev_month_price_rate = to_percentage(table.price_sum.to_f/prev_month_table.price_sum)
    end

    if (prev_year_table.count_sum == 0)
      @prev_year_count_rate = '-'
      @prev_year_price_rate = '-'
    else
      @prev_year_count_rate = to_percentage(table.count_sum.to_f/prev_month_table.count_sum)
      @prev_year_price_rate = to_percentage(table.price_sum.to_f/prev_month_table.price_sum)
    end
  end
end
