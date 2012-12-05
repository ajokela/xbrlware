require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestXbrlUtil < Test::Unit::TestCase
  def test_file_grep
    files_map = Xbrlware::file_grep(File.dirname(__FILE__) + '/resources/util_test_xbrl_files/')
    assert_equal("def.xml", bname(files_map["def"]))
    assert_equal("instance.xml", bname(files_map["ins"]))
    assert_equal("pre.xml", bname(files_map["pre"]))
    assert_equal("lab.xml", bname(files_map["lab"]))
    assert_equal("cal.xml", bname(files_map["cal"]))
    assert_equal("taxonomy.xsd", bname(files_map["tax"]))
  end

  private
  def bname(filename)
    File.basename(filename) unless filename.nil? 
  end
end