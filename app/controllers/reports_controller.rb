#encoding: utf-8
class ReportsController < ApplicationController

  before_filter :set_spot, :only => [:spot_output, :generate_spot_output, :spot_output_rate, :generate_spot_output_rate,
                                     :spot_checkin, :spot_agent_output, :spot_month_reservations,
                                     :generate_spot_checkin, :generate_spot_agent_output, :generate_spot_month_reservations]
  before_filter :set_agent, :only => [:agent_output, :agent_output_rate, :agent_checkin, :agent_spot_output, :agent_user_output,
                                      :generate_agent_output, :generate_agent_output_rate, :generate_agent_checkin, :generate_agent_spot_output,
                                      :generate_agent_user_output]

  layout 'application', :except => [:generate_spot_output, :generate_spot_output_rate, :generate_agent_user_output,
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

  def agent_user_output
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
    #@start_time = get_start_parameters_by_rate
    #@search = params[:year]+"年"+params[:month]+"月"
    #@group_no = params[:group_no]
    #@agent_name = params[:agent_name]
    #condition = {}
    #condition[:reservations] = {:created_at => @start_time..@start_time.end_of_month}
    #if @group_no.present?
    #  condition[:reservations] = {:group_no.matches => "%#{@group_no}%"}
    #end
    #if @agent_name.present?
    #  condition[:agent] = {:name.matches => "%#{@agent_name}%"}
    #end
    ##@table = @spot.reservations.exclude_canceled.where(:created_at => @start_time..@start_time.end_of_month).reorder(:agent_id).all
    #@table = @spot.reservations.joins(:agent).exclude_canceled.where(condition).reorder(:agent_id).all
    #@total_adult_ticket_number = @table.sum(&:adult_ticket_number)
    #@total_child_ticket_number = @table.sum(&:child_ticket_number)
    #@total_book_price = @table.sum(&:book_price)
    #@total_book_purchase_price = @table.sum(&:book_purchase_price)
    @search_time = params[:year]+"年"+params[:month]+"月"
    @start_time = get_start_parameters_by_rate
    @end_time = @start_time.end_of_month
    condition = generate_common_report_condition
    @reservationsTable = generate_spot_reservations_table_by_create(condition, @start_time, @end_time)
    @table = @spot.reservations.joins(:agent).where(condition).exclude_canceled.sum_agent_output_between(@start_time, @end_time)
  end


  def generate_spot_month_output
    @start_time = get_start_parameters_by_rate
    @search = params[:year]+"年"+params[:month]+"月"
    @table = @spot.reservations.exclude_canceled.sum_month_output_with_agents(@start_time, @start_time.end_of_month)
  end

  def generate_spot_output
    @start_time, @end_time = get_start_and_end_parameters
    condition = generate_common_report_condition
    @reservationsTable = generate_spot_reservations_table_by_create(condition, @start_time, @end_time)
    @table = @spot.reservations.joins(:agent).where(condition).exclude_canceled.sum_output_between(@start_time, @end_time)
  end


  def generate_agent_output
    @start_time, @end_time = get_start_and_end_parameters
    condition = generate_common_report_condition
    @reservationsTable = generate_reservations_table_by_create(condition, @start_time, @end_time)
    @table = @agent.reservations.joins(:spot).joins(:user).where(condition).exclude_canceled.sum_output_between(@start_time, @end_time)
  end


  def generate_spot_checkin
    @start_time, @end_time = get_start_and_end_parameters
    condition = generate_common_report_condition
    checkin_condition = condition;
    checkin_condition[0].concat(" and reservations.status = :checkin_status ")
    checkin_condition[1][:checkin_status] = "checkedin"
    @reservationsTable = generate_spot_reservations_table_by_create(checkin_condition, @start_time, @end_time)
    @table = @spot.reservations.joins(:agent).where(condition).exclude_canceled.sum_checkin_between(@start_time, @end_time)
  end

  def generate_agent_checkin
    @start_time, @end_time = get_start_and_end_parameters
    condition = generate_common_report_condition
    checkin_condition = condition;
    checkin_condition[0].concat(" and reservations.status = :checkin_status ")
    checkin_condition[1][:checkin_status] = "checkedin"
    @reservationsTable = generate_reservations_table_by_date(checkin_condition, @start_time, @end_time)

    @table = @agent.reservations.joins(:spot).joins(:user).where(condition).exclude_canceled.sum_checkin_between(@start_time, @end_time)
  end

  def generate_spot_agent_output
    @start_time, @end_time = get_start_and_end_parameters
    condition = generate_common_report_condition
    @reservationsTable = generate_spot_reservations_table_by_date(condition, @start_time, @end_time)
    @table = @spot.reservations.joins(:agent).where(generate_common_report_condition).exclude_canceled.sum_agent_output_between(@start_time, @end_time)
  end

  def generate_agent_spot_output
    @start_time, @end_time = get_start_and_end_parameters
    condition = generate_common_report_condition
    @reservationsTable = generate_reservations_table_by_date(condition, @start_time, @end_time)
    @table = @agent.reservations.joins(:user).where(condition).exclude_canceled.sum_spot_output_between(@start_time, @end_time)
  end

  def generate_agent_user_output
    @start_time, @end_time = get_start_and_end_parameters
    condition = generate_common_report_condition
    @reservationsTable = generate_reservations_table_by_create(condition, @start_time, @end_time)
    @table = @agent.reservations.joins(:spot).joins(:user).where(condition).exclude_canceled.sum_user_output_between(@start_time, @end_time)
  end

  def generate_agent_output_rate
    @start_time = get_start_parameters_by_rate
    condition = generate_common_report_condition
    @reservationsTable = generate_reservations_table_by_create(condition, @start_time, @start_time.end_of_month)

    @table = @agent.reservations.joins(:spot).joins(:user).where(condition).exclude_canceled.sum_output_between(@start_time, @start_time.end_of_month)
    @prev_month_table = @agent.reservations.joins(:spot).joins(:user).where(condition).exclude_canceled.sum_output_between(@start_time.prev_month, @start_time.end_of_month.prev_month)
    @prev_year_table = @agent.reservations.joins(:spot).joins(:user).where(condition).exclude_canceled.sum_output_between(@start_time.prev_year, @start_time.end_of_month.prev_year)
    calculate_rate(@table, @prev_month_table, @prev_year_table)
  end

  def generate_spot_output_rate
    @start_time = get_start_parameters_by_rate
    condition = generate_common_report_condition
    @reservationsTable = generate_spot_reservations_table_by_create(condition, @start_time, @start_time.end_of_month)
    @table = @spot.reservations.joins(:agent).where(condition).exclude_canceled.sum_output_between(@start_time, @start_time.end_of_month)
    @prev_month_table = @spot.reservations.joins(:agent).where(condition).exclude_canceled.sum_output_between(@start_time.prev_month, @start_time.end_of_month.prev_month)
    @prev_year_table = @spot.reservations.joins(:agent).where(condition).exclude_canceled.sum_output_between(@start_time.prev_year, @start_time.end_of_month.prev_year)
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
      when 'date_range'
        start_date = DateTime.parse(params[:start_report_time]).beginning_of_day
        end_date = DateTime.parse(params[:end_report_time]).end_of_day
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

  def generate_common_report_condition
    where_sql = " 1=1 ";
    where_params = {};
    condition = [where_sql, where_params]
    @agent_name = params[:agent_name]
    if @agent_name.present?
      where_sql.concat(" and agents.name like :agent_name ")
      where_params[:agent_name] = "%#{@agent_name}%";
    end
    @spot_name = params[:spot_name]
    if @spot_name.present?
      where_sql.concat(" and spots.name like :spot_name ")
      where_params[:spot_name] = "%#{@spot_name}%";
    end
    @group_no = params[:group_no]
    if @group_no.present?
      where_sql.concat(" and reservations.group_no like :group_no ")
      where_params[:group_no] = "%#{@group_no}%";
    end
    @reservation_no = params[:reservation_no]
    if @reservation_no.present?
      where_sql.concat(" and reservations.no like :reservation_no ")
      where_params[:reservation_no] = "%#{@reservation_no}%";
    end
    @ticket_name = params[:ticket_name]
    if @ticket_name.present?
      where_sql.concat(" and reservations.ticket_name like :ticket_name ")
      where_params[:ticket_name] = "%#{@ticket_name}%";
    end
    @userRealName = params[:userRealName]
    if @userRealName.present?
      where_sql.concat(" and users.name like :userRealName ")
      where_params[:userRealName] = "%#{@userRealName}%"
    end
    @username = params[:username]
    if @username.present?
      where_sql.concat(" and users.username like :username ")
      where_params[:username] = "%#{@username}%"
    end
    @reservation_type = params[:reservation_type]
    if  @reservation_type.present?
      where_sql.concat(" and reservations.type = :reservation_type ")
      where_params[:reservation_type] = @reservation_type
    end
    @reservation_status = params[:reservation_status]
    if  @reservation_status.present?
      where_sql.concat(" and reservations.status = :reservation_status ")
      if @reservation_status == "confirmed"
        where_sql.concat(" and reservations.date >= :current_date ")
        where_params[:current_date] = Date.today
        where_params[:reservation_status] = "confirmed"
      elsif @reservation_status == "outdated"
        where_sql.concat(" and reservations.date < :current_date ")
        where_params[:current_date] = Date.today
        where_params[:reservation_status] = "confirmed"
      else
        where_params[:reservation_status] = @reservation_status
      end
    else
      where_sql.concat(" and reservations.status != :reservation_status ")
      where_params[:reservation_status] = "canceled"
    end
    @paid_status = params[:paid_status]
    if  @paid_status.present?
      where_sql.concat(" and reservations.paid = :paid_status ")
      where_params[:paid_status] = @paid_status
    end
    @payment_method = params[:payment_method]
    if  @payment_method.present?
      where_sql.concat(" and reservations.payment_method = :payment_method ")
      where_params[:payment_method] = @payment_method
    end
    condition
  end

  def prepare_reservation_type_condition(condition)
    if current_user.is_spot_price_all != true
      if current_user.has_spot_team_price
        condition[:reservations] = {:type.eq => "TeamReservation"}
      end

      if current_user.has_spot_individual_price
        condition[:reservations] = {:type.eq => "IndividualReservation"}
      end
    end
    condition
  end

  def generate_reservations_table_by_create(condition, start_time, end_time)
    page = params[:page].to_i
    @search = @agent.reservations.joins(:spot).joins(:user).where(condition).day_between(start_time, end_time);
    @search.page(page);
  end

  def generate_reservations_table_by_date(condition, start_time, end_time)
    page = params[:page].to_i
    @search = @agent.reservations.joins(:spot).joins(:user).where(condition).date_between(start_time, end_time);
    @search.page(page);
  end

  def generate_spot_reservations_table_by_create(condition, start_time, end_time)
    page = params[:page].to_i
    @search = @spot.reservations.joins(:agent).where(condition).exclude_canceled.day_between(start_time, end_time);
    @search.page(page);
  end

  def generate_spot_reservations_table_by_date(condition, start_time, end_time)
    page = params[:page].to_i
    @search = @spot.reservations.joins(:agent).where(condition).exclude_canceled.date_between(start_time, end_time);
    @search.page(page);
  end

end
