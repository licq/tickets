#encoding: utf-8
prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf"
  pdf.text "每月销售统计报表",:size => 30

  items = [["时间",@search,"","","","",""],
          ["旅行社名称","订单号","团号","订单属性","人数","单价","总计"]]
  items += @table.map do |line|
    [line.agent.name, line.no, line.group_no, show_reservation_type(line), "#{line.adult_ticket_number}/#{line.child_ticket_number}", show_reservation_adult_price(line), show_reservation_book_total_price(line) ]
  end
  items << ["总计","","","","#{@total_adult_ticket_number}/#{@total_child_ticket_number}","","#{@total_book_price}/#{@total_book_purchase_price}"]
  pdf.table items, :border_style => :grid,:width => 600,
            :align => {0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right}
end