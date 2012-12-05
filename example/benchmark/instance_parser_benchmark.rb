require 'xbrlware'

r=Xbrlware::Report.new
class << r
  public :xbrl_files
end
files=r.xbrl_files("../../../xbrlware-wiki/sample_reports/edgar_data")

output = StringIO.new
output << "|| *Instance + Taxonomy file size (KB)* || *Time (Seconds)* ||"
output << "\n"

files.each do |file_map|
  m=Benchmark.measure do
    instance=Xbrlware.ins(file_map["ins"])
  end

  size = File.size(file_map["ins"]) / 1024.0
  size += File.size(file_map["tax"]) / 1024.0
  output << "|| " << format("%.4f", size).to_s << " || "
  output << format("%.4f", m.total).to_s << " || "
  output << "\n"
end

puts output.string
