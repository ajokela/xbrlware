require 'xbrlware'

## Assuming you have table "calculations" with below structure
# id
# element_name
# element_value
# element_label
# period_start_date
# period_end_date
# parent_id

def format_timeline(timeline) ## date format function
  return Xbrlware::DateUtil.stringify_date(timeline.value) unless timeline.is_duration?
  header = StringIO.new
  header << Xbrlware::DateUtil.stringify_date(timeline.value["end_date"]) << " : "
  header << Xbrlware::DateUtil.months_between(timeline.value["start_date"], timeline.value["end_date"]).to_s
  header << " months ( from " << Xbrlware::DateUtil.stringify_date(timeline.value["start_date"]) << ")"
  header.string
end

def to_table(cal_elements, timeline, parent=nil)
  cal_elements.each do |element|

    id="table_unique_id_or_primary_key" # replace this with db unique-id.
    p_element_id=id if parent.nil?
    p_element_id=parent unless parent.nil?

    matched_item=element.items.select {|item| timeline.to_s==item.context.period.to_s}[0]

    unless matched_item.nil?
      ### to calculation table

      element_label = element.label
      element_name=matched_item.name
      element_value=matched_item.value

      period = matched_item.context.period
      period_start_date, period_end_date = period.value["start_date"], period.value["end_date"] if period.is_duration?
      period_start_date, period_end_date = period.value, period.value if period.is_instant?
      period_start_date, period_end_date = nil, nil if period.is_forever?
      
      parent_id  = p_element_id

      # Insert to table
    end
    to_table(element.children, timeline, id) if element.has_children?
  end
end

ins=Xbrlware.ins("/data/764180/000119312510039027/mo-20091231.xml") # change this with actual instance files
cals=ins.taxonomy.callb.calculation

cals.each do |cal|
  puts"\n\n Start ::: Calculation -- #{cal.title} \n\n"
  cal.timelines.each do |timeline|
    puts"#{format_timeline(timeline)}"
    to_table(cal.arcs, timeline)
    puts "\n"
  end
  puts" End ::: Calculation -- #{cal.title}"
  puts "=" * 80
end