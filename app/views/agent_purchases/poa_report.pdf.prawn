#encoding: utf-8
prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf"

  pdf.text "散客对账单(门口现付)", :size => 30

  items = [["时间", @date, nil, nil, nil, nil, nil, nil, nil,nil],
           ["旅行社名称", @agent.name, "财务联系人", @agent.finance_contact, "财务联系电话", @agent.finance_phone, "", "", "",""],
           ["景区名称", @spot.name, "财务联系人", @spot.finance_contact, "财务联系电话", @spot.finance_phone, "", "", "",""],
           [""],
           ["订单号", "团号", "入园时间", "联系人", "销售价/结算价", "预订人数", "总销售价/结算价", "实际入园人数", "实际总销售价/结算价","返佣"]]
  items += @reservations.map do |reservation|

    [reservation.no, reservation.group_no, reservation.date, reservation.contact, "#{reservation.adult_sale_price}/#{reservation.adult_purchase_price}(#{reservation.child_sale_price}/#{reservation.child_purchase_price})",
     "#{reservation.adult_ticket_number}/#{reservation.child_ticket_number}", "#{reservation.book_price}/#{reservation.book_purchase_price}",
     "#{reservation.adult_true_ticket_number}/#{reservation.child_true_ticket_number}","#{reservation.total_price}/#{reservation.total_purchase_price}", reservation.total_price-reservation.total_purchase_price]
  end

  items << ["总计", "", "", "", "", "#{@adult_total_ticket_number}/#{@child_total_ticket_number}", "#{@book_price}/#{@book_purchase_price}",
            "#{@adult_total_true_ticket_number}/#{@child_total_true_ticket_number}", "#{@price}/#{@purchase_price}", @price-@purchase_price]

  pdf.table items, :border_style => :grid, :width => 750,
            :align => {0 => :right, 1 => :right, 2 => :right, 3 => :right, 4 => :right, 5 => :right}
end