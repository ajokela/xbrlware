require File.dirname(__FILE__) + '/../../test_helper.rb' 

class TestRSSFeedDownloader < Test::Unit::TestCase
  def test_get_xbrl_files
    rss_file=File.dirname(__FILE__) + '/resources/usgaap.rss.xml'
    downloader = Edgar::RSSFeedDownloader.new(rss_file)
    item = downloader.content["channel"][0]["item"][0]
    class << downloader
            public :get_xbrl_files
    end
    list_files = downloader.get_xbrl_files(item)
    assert_equal("http://www.sec.gov/Archives/edgar/data/72971/000095012310046578/wfc-20100331.xml",list_files[0]["edgar:url"])
  end
end

class TestHTMLFeedDownloader < Test::Unit::TestCase
  
  def test_get_xbrl_files
    html_file=File.dirname(__FILE__) + '/resources/0000930413-09-005485-index.htm'
    
    downloader = Edgar::HTMLFeedDownloader.new()
    files=downloader.download(html_file, "/tmp/")
    expected=%w{/Archives/edgar/data/81033/000093041309005485/peg-20090930.xml
                /Archives/edgar/data/81033/000093041309005485/peg-20090930.xsd
                /Archives/edgar/data/81033/000093041309005485/peg-20090930_cal.xml
                /Archives/edgar/data/81033/000093041309005485/peg-20090930_def.xml
                /Archives/edgar/data/81033/000093041309005485/peg-20090930_lab.xml
                /Archives/edgar/data/81033/000093041309005485/peg-20090930_pre.xml
              }
    assert_equal(expected.sort, downloader.links.to_a.sort)
    files.each do |file|
      File.delete(file) if File.exist?(file)
    end
  end
end
