require File.dirname(__FILE__) + '/../../../test_helper.rb'

class TestLabelLinkbase < Test::Unit::TestCase
  def initialize(test_case_class)
    super
    label_file=File.dirname(__FILE__)+"/resources/lab.xml"    
    @label_linkbase = Xbrlware::Linkbase::LabelLinkbase.new(label_file)
  end
  
  def test_get_labels_by_itemname
    l=@label_linkbase.label("bgllc_PrepaidExpensesAndOtherCurrentAssets")
    assert_equal(4, l.keys.size)
  end

  def test_get_label_by_itemname_and_role
    l=@label_linkbase.label("bgllc_PrepaidExpensesAndOtherCurrentAssets", "http://www.xbrl.org/2003/role/label")
    assert_equal("Prepaid expenses and other current assets", l.value)
    
    l=@label_linkbase.label("us-gaap_EffectOfExchangeRateOnCashAndCashEquivalents", "http://www.xbrl.org/2003/role/totalLabel")
    assert_equal("Effect of Exchange Rate Changes on Cash and Cash Equivalents", l.value)
  end
end