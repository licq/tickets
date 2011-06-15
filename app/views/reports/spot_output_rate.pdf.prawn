#encoding: utf-8
prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font "#{Prawn::BASEDIR}/data/fonts/gkai00mp.ttf"
  pdf.text "#{@spot.name}产量同比环比报表(#{@start_time.year}年#{@start_time.month}月)", :size => 30

  pdf.move_down 30
  items = [@table[0], @table[3], @prev_month_table[0].to_s + "("+ @prev_month_count_rate.to_s + ")", @prev_month_table[3].to_s + "("+ @prev_month_price_rate.to_s + ")",
           @prev_year_table[0].to_s + "(" + @prev_year_count_rate.to_s + ")", @prev_year_table[3].to_s + "(" + @prev_year_price_rate.to_s + ")" ]
  pdf.table [items], :border_style => :grid, :width => 700,
            :headers => ["当月订单总数", "当月总价", "上月订单总数(环比)", "上月总价(环比)", "去年当月订单总数(同比)", "去年当月总价(同比)"],
            :align => {0 => :right, 1 => :right, 2 => :right, 3 => :right, 4 => :right, 5 => :right}
end