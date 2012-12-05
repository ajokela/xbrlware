require 'rubygems' # you need this when xbrlware is installed as gem
require 'xbrlware'

instance_file="c-20091230.xml"
instance = Xbrlware.ins(instance_file) # Create parser instance

item_name="NetIncomeLoss" # This is the item we are interested in.
net_incomes = instance.item(item_name) # Extracts "NetIncomeLoss"

if net_incomes.size < 2
  puts item_name + " Not found.."
  return
end

curr_netincome, prev_netincome=0, 0

if net_incomes[0].context.period.value["end_date"] > net_incomes[1].context.period.value["end_date"]
  curr_netincome=net_incomes[0].value.to_f
  prev_netincome=net_incomes[1].value.to_f
else
  curr_netincome=net_incomes[1].value.to_f
  prev_netincome=net_incomes[0].value.to_f  
end

expected_netincome=prev_netincome-(prev_netincome * 0.05)

if curr_netincome < expected_netincome
  puts "Sell..." # Sell C's stocks
end
