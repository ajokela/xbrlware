require File.dirname(__FILE__) + '/../../test_helper.rb' 

class TestTuple < Test::Unit::TestCase
  @@xsd_file=File.dirname(__FILE__)+"/resources/49_tuple.xsd"
  
  def test_tuple
    xml_file=File.dirname(__FILE__)+"/resources/49/49_tuple.xml"    
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
  end
  
end