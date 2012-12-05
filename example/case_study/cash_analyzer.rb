require 'edgar'
require 'xbrlware'

d=Edgar::HTMLFeedDownloader.new
url="http://www.sec.gov/Archives/edgar/data/1281761/000119312510036446/0001193125-10-036446-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000119312510036446
d.download(url, download_dir)

ins=Xbrlware.ins(Xbrlware.file_grep(download_dir)["ins"])
fye=ins.entity_details["fiscal_end_date"]

data={}
[2009, 2008].each do |year|
  end_date=Date.parse(fye.gsub(/--/, "#{year}-"))
  items=ins.item_ctx_filter("CashAndCashEquivalentsAtCarryingValue") do |ctx|
    day_diff=(ctx.period.value-end_date).to_i
    ctx.period.is_instant? && (day_diff==0 || day_diff==1)
  end
  data[year]=items[0]
end

cash_2008=data[2008].value
cash_2009=data[2009].value

puts "Percentage increase/decrease in cash value 2008-2009 is === #{((cash_2009.to_f-cash_2008.to_f)/cash_2008.to_f) * 100}"


