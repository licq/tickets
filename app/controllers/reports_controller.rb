class ReportsController < ApplicationController

  before_filter :set_spot

  def output_for_date_span
    table = @spot.reservations.day_between('2011-05-16','2011-06-06')
    table.add_column("create_date") { |r| r.created_at.to_date }

    group = Grouping(table, :by => "create_date")
    s = group.summary(:create_date, :reservation_count =>lambda{|g| g.size},
                      :adult_ticket_number =>lambda{|g| g.sum("adult_ticket_number")},
                      :child_ticket_number =>lambda{|g| g.sum("child_ticket_number")},
                      :total_price => lambda{|g| g.sum("calculate_price")},
                      :order => [:create_date,:reservation_count,:adult_ticket_number,:child_ticket_number,:total_price] )

    @html = s.to_html
  end
end
