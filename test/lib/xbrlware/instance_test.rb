require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestXbrlInstance < Test::Unit::TestCase

  @@xsd_file=File.dirname(__FILE__)+"/resources/us_gaap_schema_local.xsd"

  def setup
    xml_file=File.dirname(__FILE__)+"/resources/instance.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    @xbrl = Xbrlware::Instance.new(xml_file)
  end

  def test_get_all_contexts
    ctx = @xbrl.context
    assert_equal(8, ctx.size)
  end

  def test_get_context_by_dimension
    ctx = @xbrl.context(nil, ["us-gaap:StatementEquityComponentsAxis"])
    assert_equal(4, ctx.size)

    ctx = @xbrl.context(nil, ["us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis"])
    assert_equal(2, ctx.size)

    ctx = @xbrl.context(nil, ["doesnot_exist"])
    assert_equal(0, ctx.size)
  end


  def test_ctx_groupby_dimension
    group=@xbrl.ctx_groupby_dim
    assert_equal(2, group.keys.size)
    assert_equal(4, group["us-gaap:StatementEquityComponentsAxis"].size)
    assert_equal(2, group["us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis"].size)
  end

  def test_ctx_groupby_domain
    group=@xbrl.ctx_groupby_dom
    assert_equal(2, group.keys.size)
    assert_equal(4, group["us-gaap:CommonStockMember"].size)
    assert_equal(2, group["us-gaap:AdjustableRateResidentialMortgageMember"].size)
  end

  def test_ctx_groupby_domain_for_a_dimension
    group=@xbrl.ctx_groupby_dom(["us-gaap:StatementEquityComponentsAxis"])
    assert_equal(1, group.keys.size)
    assert_equal(4, group["us-gaap:CommonStockMember"].size)

    group=@xbrl.ctx_groupby_dom(["us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis"])
    assert_equal(1, group.keys.size)
    assert_equal(2, group["us-gaap:AdjustableRateResidentialMortgageMember"].size)
  end


  def test_ctx_groupby_period
    group = @xbrl.ctx_groupby_period
    assert_equal(6, group.keys.size)
    period = Xbrlware::Context::Period.new(
            {"start_date"=> Date.parse("2008-01-02"), "end_date" => Date.parse("2008-12-30")}
    )
    assert_equal(2, group[period].size)
  end

  def test_context_for_item
    ctxs=@xbrl.context_for_item("ProfitLoss")
    assert_equal(6, ctxs.size)
  end

  def test_item_ctx_filter
    items=@xbrl.item_ctx_filter("ProfitLoss")
    assert_equal(6, items.size)

    items=@xbrl.item_ctx_filter("ProfitLoss") {|ctx| ctx.has_explicit_dimensions?}
    assert_equal(4, items.size)

    items=@xbrl.item_ctx_filter("ProfitLoss") {|ctx| ctx.has_explicit_dimensions?(["us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis"])}
    assert_equal(2, items.size)

    items=@xbrl.item_ctx_filter("ProfitLoss") {|ctx| ctx.explicit_domains==["us-gaap:CommonStockMember"]}
    assert_equal(2, items.size)

    items=@xbrl.item_ctx_filter("ProfitLoss") {|ctx| ctx.explicit_domains==["us-gaap:CommonStockMember", "us-gaap:AdjustableRateResidentialMortgageMember"]}
    assert_equal(2, items.size)
  end

  def test_get_all_units
    units=@xbrl.unit
    assert_equal(2, units.size)
  end

  def test_get_unit_by_id
    unit=@xbrl.unit("USD")
    assert_not_nil(unit)

    unit=@xbrl.unit("not-exist")
    assert_nil(unit)
  end

  def test_taxonomy
    taxonomy_detail=@xbrl.taxonomy.definition("IncomeBeforeIncomeTaxes")
    assert_not_nil(taxonomy_detail)
  end

  def test_item_with_taxonomy

    items=@xbrl.item("IncomeBeforeIncomeTaxes")
    assert_not_nil(items)
    assert_equal(1, items.size)
    assert_equal("credit", items[0].def["xbrli:balance"])
    assert_equal("credit", items[0].meta["xbrli:balance"])

    # taxonomy elements are created as instance methods and instance variable
    # at runtime using ruby meta feature
    # "-" is not valid in method / variable name. The below test covers this scenario
    items=@xbrl.item("Income-Before-IncomeTaxes")
    assert_not_nil(items)
    assert_equal(1, items.size)
    assert_equal("credit", items[0].meta["xbrli:balance"])
  end

  def test_create_instance_from_xbrl_string
    xbrl_content=%{
      <?xml version="1.0" encoding="US-ASCII"?>
      <xbrli:xbrl xmlns:xbrli="http://www.xbrl.org/2003/instance" xmlns:dei="http://xbrl.us/dei/2009-01-31" xmlns:iso4217="http://www.xbrl.org/2003/iso4217"
       xmlns:link="http://www.xbrl.org/2003/linkbase" xmlns:us-gaap="http://xbrl.us/us-gaap/2009-01-31"
       xmlns:xbrldi="http://xbrl.org/2006/xbrldi" xmlns:xlink="http://www.w3.org/1999/xlink"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:local="http://xbrl_us_gaap_local">
          <link:schemaRef xlink:href="us_gaap_schema_local.xsd" xlink:type="simple"/>
          <xbrli:context id="I2007Q">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
                  <xbrli:segment>
                      <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">us-gaap:CommonStockMember</xbrldi:explicitMember>
                  </xbrli:segment>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2007-01-02</xbrli:startDate>
                  <xbrli:endDate>2007-03-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2008Q">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
                  <xbrli:segment>
                      <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">us-gaap:CommonStockMember</xbrldi:explicitMember>
                  </xbrli:segment>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2008-01-02</xbrli:startDate>
                  <xbrli:endDate>2008-03-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

          <xbrli:context id="I2007Y-ADJ">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
                  <xbrli:segment>
                      <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">us-gaap:CommonStockMember</xbrldi:explicitMember>
                      <xbrldi:explicitMember dimension="us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis">us-gaap:AdjustableRateResidentialMortgageMember</xbrldi:explicitMember>
                  </xbrli:segment>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2007-01-02</xbrli:startDate>
                  <xbrli:endDate>2007-12-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2008Y-ADJ">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
                  <xbrli:segment>
                      <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">us-gaap:CommonStockMember</xbrldi:explicitMember>
                      <xbrldi:explicitMember dimension="us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis">us-gaap:AdjustableRateResidentialMortgageMember</xbrldi:explicitMember>
                  </xbrli:segment>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2008-01-02</xbrli:startDate>
                  <xbrli:endDate>2008-12-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2007Y">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2007-01-02</xbrli:startDate>
                  <xbrli:endDate>2007-12-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2008Y">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2008-01-02</xbrli:startDate>
                  <xbrli:endDate>2008-12-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2008">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">0000056873</xbrli:identifier>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:instant>2008-12-30</xbrli:instant>
              </xbrli:period>
          </xbrli:context>
          <xbrli:context id="I2007">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">0000056873</xbrli:identifier>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:instant>2007-12-30</xbrli:instant>
              </xbrli:period>
          </xbrli:context>

          <xbrli:unit id="USD">
              <xbrli:measure>iso4217:USD</xbrli:measure>
          </xbrli:unit>

          <xbrli:unit id="AUD">
              <xbrli:measure>iso4217:AUD</xbrli:measure>
          </xbrli:unit>

          <us-gaap:ProfitLoss contextRef="I2007Q"  decimals="-6" unitRef="USD">947000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2008Q" unitRef="USD" decimals="-6">702000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2007Y-ADJ" unitRef="USD" decimals="-6">802000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2008Y-ADJ" unitRef="USD" decimals="-6">902000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2007Y" unitRef="USD" decimals="-6">805000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2008Y" unitRef="USD" decimals="-6">905000000</us-gaap:ProfitLoss>
          <us-gaap:ReceivablesNetCurrent contextRef="I2007" decimals="-6" unitRef="USD">944000000</us-gaap:ReceivablesNetCurrent>
          <us-gaap:ReceivablesNetCurrent contextRef="I2008" decimals="-6" unitRef="USD">945000000</us-gaap:ReceivablesNetCurrent>
          <local:IncomeBeforeIncomeTaxes contextRef="I2007Q" unitRef="USD" decimals="-6">902000000</local:IncomeBeforeIncomeTaxes>
          <local:Income-Before-IncomeTaxes contextRef="I2008Q" unitRef="USD" decimals="-6">902000000</local:Income-Before-IncomeTaxes>
      </xbrli:xbrl>
    }
    @xbrl = Xbrlware::Instance.new(xbrl_content)

    items=@xbrl.item("IncomeBeforeIncomeTaxes")
    assert_not_nil(items)
    assert_equal(1, items.size)
  end

  def test_item_all_map
    items=@xbrl.item_all_map
    assert_equal(6, items["PROFITLOSS"].size)
    assert_equal(2, items["RECEIVABLESNETCURRENT"].size)
    assert_equal(1, items["INCOMEBEFOREINCOMETAXES"].size)
    assert_equal(1, items["INCOME-BEFORE-INCOMETAXES"].size)
    assert_nil(items["NOT-EXIST"])
  end


  def test_item_all
    items=@xbrl.item_all
    assert_equal(10, items.size)
  end  

  def test_entity_details
    entity_details=@xbrl.entity_details
    assert_equal("UNKNOWN", entity_details["name"])

    @xbrl.entity_details={"name" => "EntityName"}
    assert_equal("EntityName", entity_details["name"])
    assert_equal("UNKNOWN", entity_details["ci_keys"])

  end

  def test_create_instance_from_improper_xbrl_string
    xbrl_content=%{
      <?xml version="1.0" encoding="US-ASCII"?>
      <xbrli:xbrl xmlns:xbrli="http://www.xbrl.org/2003/instance" xmlns:dei="http://xbrl.us/dei/2009-01-31" xmlns:iso4217="http://www.xbrl.org/2003/iso4217"
       xmlns:link="http://www.xbrl.org/2003/linkbase" xmlns:us-gaap="http://xbrl.us/us-gaap/2009-01-31"
       xmlns:xbrldi="http://xbrl.org/2006/xbrldi" xmlns:xlink="http://www.w3.org/1999/xlink"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:local="http://xbrl_us_gaap_local">
          <link:schemaRef xlink:href="us_gaap_schema_local.xsd" xlink:type="simple"/>
          <xbrli:context id="I2007Q">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
                  <xbrli:segment>
                      <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">us-gaap:CommonStockMember</xbrldi:explicitMember>
                  </xbrli:segment>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2007-01-02</xbrli:startDate>
                  <xbrli:endDate>2007-03-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2008Q">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
                  <xbrli:segment>
                      <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">us-gaap:CommonStockMember</xbrldi:explicitMember>
                  </xbrli:segment>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2008-01-02</xbrli:startDate>
                  <xbrli:endDate>2008-03-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

          <xbrli:context id="I2007Y-ADJ">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
                  <xbrli:segment>
                      <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">us-gaap:CommonStockMember</xbrldi:explicitMember>
                      <xbrldi:explicitMember dimension="us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis">us-gaap:AdjustableRateResidentialMortgageMember</xbrldi:explicitMember>
                  </xbrli:segment>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2007-01-02</xbrli:startDate>
                  <xbrli:endDate>2007-12-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2008Y-ADJ">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
                  <xbrli:segment>
                      <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">us-gaap:CommonStockMember</xbrldi:explicitMember>
                      <xbrldi:explicitMember dimension="us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis">us-gaap:AdjustableRateResidentialMortgageMember</xbrldi:explicitMember>
                  </xbrli:segment>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2008-01-02</xbrli:startDate>
                  <xbrli:endDate>2008-12-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2007Y">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2007-01-02</xbrli:startDate>
                  <xbrli:endDate>2007-12-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2008Y">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">
                      0000056873
                  </xbrli:identifier>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:startDate>2008-01-02</xbrli:startDate>
                  <xbrli:endDate>2008-12-30</xbrli:endDate>
              </xbrli:period>
          </xbrli:context>

            <xbrli:context id="I2008">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">0000056873</xbrli:identifier>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:instant>2008-12-30</xbrli:instant>
              </xbrli:period>
          </xbrli:context>
          <xbrli:context id="I2007">
              <xbrli:entity>
                  <xbrli:identifier scheme="http://www.sec.gov/CIK">0000056873</xbrli:identifier>
              </xbrli:entity>
              <xbrli:period>
                  <xbrli:instant>2007-12-30</xbrli:instant>
              </xbrli:period>
          </xbrli:context>

          <xbrli:unit id="USD">
              <xbrli:measure>iso4217:USD</xbrli:measure>
          </xbrli:unit>

          <xbrli:unit id="AUD">
              <xbrli:measure>iso4217:AUD</xbrli:measure>
          </xbrli:unit>

          <us-gaap:ProfitLoss contextRef="I2007Q"  decimals="-6" unitRef="USD">947000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2008Q" unitRef="USD" decimals="-6">702000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2007Y-ADJ" unitRef="USD" decimals="-6">802000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2008Y-ADJ" unitRef="USD" decimals="-6">902000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2007Y" unitRef="USD" decimals="-6">805000000</us-gaap:ProfitLoss>
          <us-gaap:ProfitLoss contextRef="I2008Y" unitRef="USD" decimals="-6">905
          000000</us-gaap:ProfitLoss>
          <us-gaap:ReceivablesNetCurrent contextRef="I2007" decimals="-6" unitRef="USD">944000000</us-gaap:ReceivablesNetCurrent>
          <us-gaap:ReceivablesNetCurrent contextRef="I2008" decimals="-6" unitRef="USD">945000000</us-gaap:ReceivablesNetCurrent>
          <local:IncomeBeforeIncomeTaxes contextRef="I2007Q" unitRef="USD" decimals="-6">902000000</local:IncomeBeforeIncomeTaxes>
          <local:Income-Before-IncomeTaxes contextRef="I2008Q" unitRef="USD" decimals="-6">902000000</local:Income-Before-IncomeTaxes>
      </xbrli:xbrl>
    }
    @xbrl = Xbrlware::Instance.new(xbrl_content)

    items=@xbrl.item("IncomeBeforeIncomeTaxes")
    assert_not_nil(items)
    assert_equal(1, items.size)
  end

end