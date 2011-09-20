#encoding: utf-8
prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf"
  pdf.text "#{@agent.name}景区销售业绩报表(#{@start_time.to_date}~#{@end_time.to_date})",:size => 30

  pdf.move_down 30

  items = [["预订人数(成人/儿童)","入园日期","实际人数(成人/儿童)","总价(销售价/(结算价))","结算情况"]]
  items += @search.map do |line|
    ["#{line.adult_ticket_number}/#{line.child_ticket_number}", line.date, show_reservation_true_tickets_number(line), show_reservation_total_price(line), line.settled_name]
  end
  pdf.table items, :border_style => :grid,:width => 600,
            :align => {0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right}

  items = @table.map do |line|
    [line.spot_name, line.count_sum, line.adult_ticket_sum.to_i, line.child_ticket_sum.to_i, line.price_sum.to_i]
  end
  pdf.table items, :border_style => :grid,:width => 600,
            :headers => ["景区名称","订单总数", "成人总数", "儿童总数", "总价"],
            :align => {0 => :left, 1 => :right, 2 => :right}
end