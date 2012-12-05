require File.dirname(__FILE__) + '/../../../test_helper.rb'

class TestContextExplicitDimension < Test::Unit::TestCase
  
  def initialize(test_case)
    super(test_case)
    xml_file=File.dirname(__FILE__)+"/resources/context_explicit_dimension.xml"    
    @xbrl = Xbrlware::Instance.new(xml_file)
  end
  
  def test_explicit_dimensions
    ctx=@xbrl.context("I2008_Ctx")
    expected=["us-gaap:StatementEquityComponentsAxis", "us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis"]
    assert_equal(expected, ctx.explicit_dimensions)
  end
  
  def test_explicit_domains
    ctx=@xbrl.context("I2009_Ctx")
    
    expected=["us-gaap:CommonStockMember", "us-gaap:AdjustableRateResidentialMortgageMember", "us-gaap:PreferredStockMember"]
    assert_equal(expected, ctx.explicit_domains)
    
    dimensions=["us-gaap:StatementEquityComponentsAxis", "us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis", "us-gaap:StatementEquityComponentsAxis"]
    assert_equal(expected, ctx.explicit_domains(dimensions))
    
    dimensions=["us-gaap:StatementEquityComponentsAxis", "us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis"]
    assert_equal(expected, ctx.explicit_domains(dimensions))    
    
    dimensions=["us-gaap:StatementEquityComponentsAxis"]
    expected=["us-gaap:CommonStockMember", "us-gaap:PreferredStockMember"]
    assert_equal(expected, ctx.explicit_domains(dimensions))
  end
  
  def test_explicit_dimensions_domains
    ctx=@xbrl.context("I2009_Ctx")
    dims_doms=ctx.explicit_dimensions_domains
    assert_equal(["us-gaap:CommonStockMember", "us-gaap:PreferredStockMember"], dims_doms["us-gaap:StatementEquityComponentsAxis"])
    assert_equal(["us-gaap:AdjustableRateResidentialMortgageMember"], dims_doms["us-gaap:IndefiniteLivedIntangibleAssetsBySegmentAxis"])
  end  
end