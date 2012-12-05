require File.dirname(__FILE__) + '/../../test_helper.rb'
class TestUnit < Test::Unit::TestCase
  @@xsd_file=File.dirname(__FILE__)+"/resources/us_gaap_schema_local.xsd"

  def test_48_get_all_units
    xml_file=File.dirname(__FILE__)+"/resources/48/48_multiple_units.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    units=xbrl.unit
    assert_equal(2, units.size)
  end

  def test_48_unit_by_id
    xml_file=File.dirname(__FILE__)+"/resources/48/48_multiple_units.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    
    unit=xbrl.unit("USD_multipy_by_shares")
    assert_not_nil(unit)

    unit=xbrl.unit("not_exist")
    assert_nil(unit)    
  end

  def test_482_measure
    xml_file=File.dirname(__FILE__)+"/resources/48/482_unit_measure.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    unit = xbrl.unit("USD_multipy_by_shares")
    assert_equal("iso4217:USD", unit.measure[0])
    assert_equal("xbrli:shares", unit.measure[1])
  end

  def test_483_and_484_divide
    xml_file=File.dirname(__FILE__)+"/resources/48/483_unit_divide.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    unit = xbrl.unit("USDPerShare")
    assert(unit.measure.is_a?(Xbrlware::Unit::Divide))
    assert_equal("iso4217:USD", unit.measure.numerator[0])
    assert_equal("iso4217:AUD", unit.measure.numerator[1])
    assert_equal("xbrli:shares", unit.measure.denominator[0])
    assert_equal("xbrli:pure", unit.measure.denominator[1])
  end

  def test_unit_namespace_and_prefix
    xml_file=File.dirname(__FILE__)+"/resources/48/482_unit_measure.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    unit = xbrl.unit("USD_multipy_by_shares")
    assert_equal("http://www.xbrl.org/2003/instance", unit.ns)
    assert_equal("xbrli", unit.nsp)
  end
  
end