require 'rubygems' # you need this when xbrlware is installed as gem
require 'edgar'
require 'xbrlware'

dl=Edgar::HTMLFeedDownloader.new()

url="http://www.sec.gov/Archives/edgar/data/843006/000135448809002030/0001354488-09-002030-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000135448809002030
dl.download(url, download_dir)

instance_file=Xbrlware.file_grep(download_dir)["ins"]
instance=Xbrlware.ins(instance_file)

item_name="Assets"
assets = instance.item(item_name) # Extracts "Assets"

if assets.size < 2
  puts item_name + " Not found.."
  return
end

curr_asset, prev_asset=0, 0

if assets[0].context.period.value > assets[1].context.period.value
  curr_asset=assets[0].value.to_f
  prev_asset=assets[1].value.to_f
else
  curr_asset=assets[1].value.to_f
  prev_asset=assets[0].value.to_f
end

if curr_asset > prev_asset
  puts "Buy..."
end
