#encoding: utf-8
prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf"
  pdf.text "#{@agent.name}景区销售业绩报表(#{@start_time.to_date}~#{@end_time.to_date})",:size => 30

  pdf.move_down 30
  items = @table.map do |line|
    [line.spot_name, line.count_sum, line.adult_ticket_sum, line.child_ticket_sum, line.price_sum]
  end
  pdf.table items, :border_style => :grid,:width => 600,
            :headers => ["景区名称","订单总数", "成人总数", "儿童总数", "总价"],
            :align => {0 => :left, 1 => :right, 2 => :right}
end