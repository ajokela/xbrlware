require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestSchemaRefContext < Test::Unit::TestCase
  
  @@xsd_file=File.dirname(__FILE__)+"/resources/us_gaap_schema_local.xsd"
  
  def test_42_schema_ref_with_base
    xml_file=File.dirname(__FILE__)+"/resources/42/42_schema_ref_with_base.xml"    
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    assert_equal("http://www.a.com/schema.xsd", xbrl.schema_ref)
  end
  
  def test_42_schema_ref_without_base
    xml_file=File.dirname(__FILE__)+"/resources/42/42_schema_ref_without_base.xml"    
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    assert_equal("schema.xsd", xbrl.schema_ref)
  end  
end