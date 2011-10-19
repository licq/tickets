#encoding: utf-8
prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf"
  pdf.text "#{@spot.name}产量报表(#{@start_time.to_date}~#{@end_time.to_date})",:size => 30

  pdf.move_down 30

   items = [["订单号","团号","旅行社","门票种类","入园日期","订单种类","成人价(销售价/(结算价))","儿童价(销售价/(结算价))","预订成人票","预订儿童票","实际成人票","实际儿童票","总价(销售价/(结算价))","支付方式","预订日期","入园状态","支付状态","结算状态"]]
      items += @search.map do |line|
        [line.no,show_group_no(line.group_no),"#{line.agent.name}",line.ticket_name, line.date,show_reservation_type(line),show_reservation_adult_price(line),show_reservation_child_price(line),"#{line.adult_ticket_number}","#{line.child_ticket_number}", "#{line.adult_true_ticket_number}","#{line.child_true_ticket_number}", show_reservation_total_price(line),show_reservation_payment_method(line),date_format(line.created_at),line.status_name,line.paid_name, line.settled_name]
      end
      pdf.table items, :border_style => :grid,:width => 700,
                :align => {0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right, 7 => :right, 8 => :right, 9 => :right, 10 => :right, 11 => :right, 12 => :right, 13 => :right, 14 => :right, 15 => :right, 16 => :right, 17 => :right}


  pdf.table [[@table.count_sum.to_i, @table.adult_ticket_sum.to_i, @table.child_ticket_sum.to_i,@table.adult_true_ticket_sum.to_i,@table.child_true_ticket_sum.to_i, @table.price_sum.to_i]], :border_style => :grid,:width => 700,
            :headers => ["订单总数", "预订成人票", "预订儿童票", "实际成人票","实际儿童票","总价"],
            :align => {0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right, 5 => :right}
end