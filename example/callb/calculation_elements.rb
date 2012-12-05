require 'xbrlware'

def format_timeline(timeline) ## date format function
  return Xbrlware::DateUtil.stringify_date(timeline.value) unless timeline.is_duration?
  header = StringIO.new
  header << Xbrlware::DateUtil.stringify_date(timeline.value["end_date"]) << " : "
  header << Xbrlware::DateUtil.months_between(timeline.value["start_date"], timeline.value["end_date"]).to_s
  header << " months ( from " << Xbrlware::DateUtil.stringify_date(timeline.value["start_date"]) << ")"
  header.string
end

def print_cal(cal_elements, timeline, indent_count=0)
  cal_elements.each_with_index do |element, index|
    indent=" " * indent_count
    matched_item=element.items.select {|item| timeline.to_s==item.context.period.to_s}[0]
    puts "#{indent} #{element.label} (#{matched_item.name}) = #{matched_item.value}" unless matched_item.nil?
    print_cal(element.children, timeline, index+1) if element.has_children?
  end
end

ins=Xbrlware.ins("/data/764180/000119312510039027/mo-20091231.xml") # change this with actual instance files
cals=ins.taxonomy.callb.calculation

cals.each do |cal|
  puts"\n\n Start ::: Calculation -- #{cal.title} \n\n"
  cal.timelines.each do |timeline|
    puts"#{format_timeline(timeline)}"
    print_cal(cal.arcs, timeline)
    puts "\n"
  end
  puts" End ::: Calculation -- #{cal.title}"
  puts "=" * 80
end