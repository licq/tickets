#encoding: utf-8
prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf"
  pdf.text "#{@spot.name}产量同比环比报表(#{@start_time.year}年#{@start_time.month}月)", :size => 30

  pdf.move_down 30

  items = [["预订人数(成人/儿童)","入园日期","实际人数(成人/儿童)","总价(销售价/(结算价))","结算情况"]]
    items += @search.map do |line|
      ["#{line.adult_ticket_number}/#{line.child_ticket_number}", line.date, show_reservation_true_tickets_number(line), show_reservation_total_price(line), line.settled_name]
    end
    pdf.table items, :border_style => :grid,:width => 700,
              :align => {0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right}

  items = [@table.count_sum, @table.price_sum.to_i, "#{@prev_month_table.count_sum}(#{@prev_month_count_rate})", "#{@prev_month_table.price_sum.to_i}(#{@prev_month_price_rate})",
           "#{@prev_year_table.count_sum}(#{@prev_year_count_rate})", "#{@prev_year_table.price_sum.to_i}(#{@prev_year_price_rate})"]
  pdf.table [items], :border_style => :grid, :width => 700,
            :headers => ["当月订单总数", "当月总价", "上月订单总数(环比)", "上月总价(环比)", "去年当月订单总数(同比)", "去年当月总价(同比)"],
            :align => {0 => :right, 1 => :right, 2 => :right, 3 => :right, 4 => :right, 5 => :right}
end