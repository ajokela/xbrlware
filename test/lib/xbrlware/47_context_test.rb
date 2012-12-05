require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestContext < Test::Unit::TestCase

  @@xsd_file=File.dirname(__FILE__)+"/resources/us_gaap_schema_local.xsd"

  def test_472_period_start_dt_and_end_dt
    xml_file=File.dirname(__FILE__)+"/resources/47/472_period_start_dt_and_end_dt.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    p=xbrl.context("I2007_CommonStockMember").period
    assert_equal("2008-02-02", p.value["start_date"].to_s)
    assert_equal("2008-03-02", p.value["end_date"].to_s)
    assert(p.is_duration?)
    assert_equal(false, p.is_instant?)
    assert_equal(false, p.is_forever?)
  end

  def test_472_period_instant
    xml_file=File.dirname(__FILE__)+"/resources/47/472_period_instant.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    ctx=xbrl.context("I2007_CommonStockMember")
    p=ctx.period
    assert_equal("2008-02-02", p.to_s)
    assert p.is_instant?
    assert_equal(false, p.is_duration?)
    assert_equal(false, p.is_forever?)
  end

  def test_472_period_forever
    xml_file=File.dirname(__FILE__)+"/resources/47/472_period_forever.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    p=xbrl.context("I2007_CommonStockMember").period
    assert_equal(Xbrlware::Context::PERIOD_FOREVER, p.value)
    assert p.is_forever?
    assert_equal(false, p.is_instant?)
    assert_equal(false, p.is_duration?)
  end

  def test_4731_entity_identifier
    xml_file=File.dirname(__FILE__)+"/resources/47/4731_entity_identifier.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    entity =xbrl.context("I2007_CommonStockMember").entity
    assert_equal("0000056873", entity.identifier.value)
    assert_equal("http://www.sec.gov/CIK", entity.identifier.scheme)
  end

  def test_4732_entity_segment_present
    xml_file=File.dirname(__FILE__)+"/resources/47/4732_entity_segment_present.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    ctx=xbrl.context("I2007_CommonStockMember")
    entity =ctx.entity
    assert_equal(2, entity.segment["explicitMember"].size)
    assert_equal("http://www.xbrl.org/2003/instance", entity.segment["nspace"])
    assert_equal("xbrli", entity.segment["nspace_prefix"])
  end

  def test_4732_entity_segment_not_present
    xml_file=File.dirname(__FILE__)+"/resources/47/4732_entity_segment_not_present.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    ctx=xbrl.context("I2007_CommonStockMember")
    entity =ctx.entity
    assert_equal(nil, entity.segment)
  end


  def test_474_scenario_present
    xml_file=File.dirname(__FILE__)+"/resources/47/474_scenario_present.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    scenario =xbrl.context("I2007_CommonStockMember").scenario
    assert_equal(2, scenario["explicitMember"].size)
    assert_equal("http://www.xbrl.org/2003/instance", scenario["nspace"])
    assert_equal("xbrli", scenario["nspace_prefix"])    
  end

  def test_474_scenario_not_present
    xml_file=File.dirname(__FILE__)+"/resources/47/474_scenario_not_present.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    scenario =xbrl.context("I2007_CommonStockMember").scenario
    assert_equal(nil, scenario)
  end

  def test_get_all_contexts
    xml_file=File.dirname(__FILE__)+"/resources/47/47_multiple_contexts.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    ctx =xbrl.context
    assert_equal(2, ctx.size)
  end

  def test_context_dimensions
    xml_file=File.dirname(__FILE__)+"/resources/instance.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    ctx=xbrl.context("I2007Q")
    assert_equal(["us-gaap:StatementEquityComponentsAxis"], ctx.explicit_dimensions)

    ctx=xbrl.context("I2007Y-ADJ")
    assert_equal(["us-gaap:StatementEquityComponentsAxis", "us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis"], ctx.explicit_dimensions)
  end

  def test_context_domains
    xml_file=File.dirname(__FILE__)+"/resources/instance.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    ctx=xbrl.context("I2007Q")
    assert_equal(["us-gaap:CommonStockMember"], ctx.explicit_domains)

    ctx=xbrl.context("I2007Y-ADJ")
    assert_equal(["us-gaap:CommonStockMember", "us-gaap:AdjustableRateResidentialMortgageMember"], ctx.explicit_domains)
  end

  def test_context_dimension_domain
    xml_file=File.dirname(__FILE__)+"/resources/instance.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    ctx=xbrl.context("I2007Y-ADJ")
    assert_equal(1, ctx.explicit_dimensions_domains["us-gaap:StatementEquityComponentsAxis"].size)
    assert_equal(1, ctx.explicit_dimensions_domains["us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis"].size)
  end

  def test_context_not_exist
    xml_file=File.dirname(__FILE__)+"/resources/instance.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    ctx=xbrl.context("not-exist")
    assert_nil(ctx)
  end

  def test_context_namespace_and_prefix
    xml_file=File.dirname(__FILE__)+"/resources/47/472_period_forever.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    xbrl = Xbrlware::Instance.new(xml_file)
    c=xbrl.context("I2007_CommonStockMember")
    assert_equal("http://www.xbrl.org/2003/instance", c.ns)
    assert_equal("xbrli", c.nsp)
  end

end