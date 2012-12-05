require 'rubygems' # you need this when xbrlware is installed as gem
require 'edgar'
require 'xbrlware'

dl=Edgar::HTMLFeedDownloader.new()

url="http://www.sec.gov/Archives/edgar/data/843006/000135448809002030/0001354488-09-002030-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000135448809002030
dl.download(url, download_dir)

# Name of xbrl documents downloaded from EDGAR system is in the following convention
#    calculation linkbase document ends with _cal.xml
#    definition linkbase document ends with _def.xml
#    presentation linkbase ends with _pre.xml
#    label linkbase document ends with _lab.xml
#    taxonomy document ends with .xsd
#    instance document ends with .xml
# Xbrl::file_grep understands above convention.  
instance_file=Xbrlware.file_grep(download_dir)["ins"] # use file_grep to filter xbrl files and get instance file

instance=Xbrlware.ins(instance_file)

items=instance.item("OtherAssetsCurrent")
puts "Other-Assets \t Context"
items.each do |item|
  puts item.value+" \t "+item.context.id
end