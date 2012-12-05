require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestItem < Test::Unit::TestCase
  @@xsd_file=File.dirname(__FILE__)+"/resources/us_gaap_schema_local.xsd"

  def test_464_precision
    value=Xbrlware::Item::ItemValue.new("476.334", "INF")
    assert_equal("476.334", value.precision)

    value=Xbrlware::Item::ItemValue.new("205", "3")
    assert_equal("205.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("2002000", "4")
    assert_equal("2002000.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("-2002000", "4")
    assert_equal("-2002000.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("123.456", "5")
    assert_equal("123.46", value.precision)

    value=Xbrlware::Item::ItemValue.new("-123.456", "5")
    assert_equal("-123.46", value.precision)

    value=Xbrlware::Item::ItemValue.new("123.456", "2")
    assert_equal("120.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("-123.456", "2")
    assert_equal("-120.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("123.456", "7")
    assert_equal("123.456", value.precision)

    value=Xbrlware::Item::ItemValue.new("-123.456", "7")
    assert_equal("-123.456", value.precision)

    value=Xbrlware::Item::ItemValue.new("123.416", "4")
    assert_equal("123.4", value.precision)

    value=Xbrlware::Item::ItemValue.new("-123.416", "4")
    assert_equal("-123.4", value.precision)

    value=Xbrlware::Item::ItemValue.new("-123.000000000416", "14")
    assert_equal("-123.00000000042", value.precision)

    value=Xbrlware::Item::ItemValue.new("0.000256", "3")
    assert_equal("0.000256", value.precision)

    value=Xbrlware::Item::ItemValue.new("-0.000256", "3")
    assert_equal("-0.000256", value.precision)

    value=Xbrlware::Item::ItemValue.new("0.000256", "2")
    assert_equal("0.00026", value.precision)

    value=Xbrlware::Item::ItemValue.new("-0.000256", "2")
    assert_equal("-0.00026", value.precision)

    value=Xbrlware::Item::ItemValue.new("0.1", "2")
    assert_equal("0.1", value.precision)

    value=Xbrlware::Item::ItemValue.new("-0.1", "2")
    assert_equal("-0.1", value.precision)

    value=Xbrlware::Item::ItemValue.new("0.49787", "2")
    assert_equal("0.5", value.precision)

    value=Xbrlware::Item::ItemValue.new("0.49787", "3")
    assert_equal("0.498", value.precision)

    value=Xbrlware::Item::ItemValue.new("9.999991", "2")
    assert_equal("10.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("9.999991", "3")
    assert_equal("10.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("0.00000000000000049787", "3")
    assert_equal("0.000000000000000498", value.precision)

    value=Xbrlware::Item::ItemValue.new("-0.00000000000000049787", "3")
    assert_equal("-0.000000000000000498", value.precision)

    value=Xbrlware::Item::ItemValue.new("12345678901234567890.00000000000000049787", "38")
    assert_equal("12345678901234567890.000000000000000498", value.precision)

    value=Xbrlware::Item::ItemValue.new("-12345678901234567890.00000000000000049787", "38")
    assert_equal("-12345678901234567890.000000000000000498", value.precision)

    value=Xbrlware::Item::ItemValue.new("12345678901234567890", "19")
    assert_equal("12345678901234567890.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("-12345678901234567890", "19")
    assert_equal("-12345678901234567890.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("12345678901234567890", "18")
    assert_equal("12345678901234567800.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("-12345678901234567890", "18")
    assert_equal("-12345678901234567800.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("123.45e5", "3")
    assert_equal("12300000.0", value.precision)

    value=Xbrlware::Item::ItemValue.new("-123.45e5", "3")
    assert_equal("-12300000.0", value.precision)
  end

  def test_465_decimals

    value=Xbrlware::Item::ItemValue.new("2.65", nil, "INF")
    assert_equal("2.65", value.decimals)

    value=Xbrlware::Item::ItemValue.new("2002000", nil, "-4")
    assert_equal("2000000.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-2002000", nil, "-4")
    assert_equal("-2000000.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("10", nil, "0")
    assert_equal("10.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-10", nil, "0")
    assert_equal("-10.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-2002000", nil, "-4")
    assert_equal("-2000000.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("123.45e5", nil, "-3")
    assert_equal("12345000.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-123.45e5", nil, "-3")
    assert_equal("-12345000.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("123.45e5", nil, "-5")
    assert_equal("12300000.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-123.45e5", nil, "-5")
    assert_equal("-12300000.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("123.45", nil, "-2")
    assert_equal("100.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-123.45", nil, "-2")
    assert_equal("-100.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("123.45", nil, "-3")
    assert_equal("0.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-123.45", nil, "-3")
    # JRUBY returns 0.0, where as MRI returns -0.0
    assert_equal(0, value.decimals.to_i)

    value=Xbrlware::Item::ItemValue.new("123.4567", nil, "2")
    assert_equal("123.46", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-123.4567", nil, "2")
    assert_equal("-123.46", value.decimals)

    value=Xbrlware::Item::ItemValue.new("123.45678999e5", nil, "2")
    assert_equal("12345679.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-123.45678999e5", nil, "2")
    assert_equal("-12345679.0", value.decimals)

    value=Xbrlware::Item::ItemValue.new("0.001E-2", nil, "5")
    assert_equal("0.00001", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-0.001E-2", nil, "5")
    assert_equal("-0.00001", value.decimals)

    value=Xbrlware::Item::ItemValue.new("0.0015E-2", nil, "5")
    assert_equal("0.00002", value.decimals)

    value=Xbrlware::Item::ItemValue.new("-0.0015E-2", nil, "5")
    assert_equal("-0.00002", value.decimals)
  end

  def test_single_item
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    items = xbrl.item("StockholdersEquityIncludingPortionAttributableToNoncontrollingInterest")
    assert_equal(1, items.size)
    assert_equal("947000000.0", items[0].value)
  end

  def test_multiple_item_for_given_itemname
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    items = xbrl.item("SalesRevenueGoodsNet")
    assert_equal(4, items.size)
    assert_equal("18094000000.0", items[0].value)
    assert_equal("15094000000.0", items[1].value)
  end


  def test_context_present
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    item = xbrl.item("StockholdersEquityIncludingPortionAttributableToNoncontrollingInterest")[0]
    assert_equal("0000056873", item.context.entity.identifier.value )
  end

  def test_unit_present
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    item = xbrl.item("StockholdersEquityIncludingPortionAttributableToNoncontrollingInterest")[0]
    assert_equal("iso4217:USD", item.unit.measure[0])
  end

  def test_item_for_itemname_and_contextref
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    items = xbrl.item("SalesRevenueGoodsNet", "D2008Q4")
    assert_equal("18094000000.0", items[0].value)
  end

  def test_item_for_itemname_and_unitref
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    items = xbrl.item("SalesRevenueGoodsNet", nil, "AUD")
    assert_equal("9047000000.0", items[0].value)
    assert_equal("7547000000.0", items[1].value)
  end

  def test_item_for_itemname_and_contextref_and_unitref
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    items = xbrl.item("SalesRevenueGoodsNet", "D2008Q4", "AUD")
    assert_equal(1, items.size)
    assert_equal("9047000000.0", items[0].value)
  end

  def test_item_formatting
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    items = xbrl.item("SalesRevenueGoodsNet", "D2008Q4", "AUD")
    assert_equal(1, items.size)
    assert_equal("9047.0", items[0].value{|value| (BigDecimal(value)/1000000).round(2).to_s("F")})
  end

  def test_empty_item
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    items = xbrl.item("CommitmentsAndContingencies2009")
    assert_equal(1, items.size)
    assert_nil(items[0].value)
  end

  def test_item_namespace_and_namespace_prefix
    xml_file=File.dirname(__FILE__)+"/resources/46/46_item_value.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    items = xbrl.item("SalesRevenueGoodsNet", "D2008Q4", "AUD")
    assert_equal("http://xbrl.us/us-gaap/2009-01-31", items[0].ns)
    assert_equal("us-gaap", items[0].nsp)
  end

  def test_is_value_numeric
    item = Xbrlware::Item.new(nil, nil, nil, "12345")
    assert item.is_value_numeric?

    item = Xbrlware::Item.new(nil, nil, nil, "12345.6789")
    assert item.is_value_numeric?

    item = Xbrlware::Item.new(nil, nil, nil, "-12345")
    assert item.is_value_numeric?

    item = Xbrlware::Item.new(nil, nil, nil, "1SS")
    assert_equal(false, item.is_value_numeric?)

    item = Xbrlware::Item.new(nil, nil, nil, "xyz")
    assert_equal(false, item.is_value_numeric?)  
  end

end