require 'rubygems' # you need this when xbrlware is installed as gem
require 'xbrlware'

instance=Xbrlware.ins("foo.xml")
items=instance.item("ProfitLoss")

puts "Profit-Loss \t Context"
items.each do |item|
  puts item.value+" \t "+item.context.id
end