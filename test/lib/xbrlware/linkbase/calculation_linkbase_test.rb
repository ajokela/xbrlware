require File.dirname(__FILE__) + '/../../../test_helper.rb'
require File.dirname(__FILE__) + '/linkbase_test_util'

class TestCalculationLinkbase < Test::Unit::TestCase
  include LinkbaseTestUtil

  def test_calculation
    calc_file=File.dirname(__FILE__)+"/resources/cal.xml"
    lab_file=File.dirname(__FILE__)+"/resources/lab.xml"
    instance_file=File.dirname(__FILE__)+"/resources/instance.xml"
    instance = Xbrlware::Instance.new(instance_file)
    label=Xbrlware::Linkbase::LabelLinkbase.new(lab_file)
    cal_linkbase = Xbrlware::Linkbase::CalculationLinkbase.new(calc_file, instance, label)
    calculation=cal_linkbase.calculation("http://pbg.com/20090613/role/StatementsOfChangesInEquity")
    assert_not_nil(calculation)
    assert_equal("StatementsOfChangesInEquity", calculation.href)

    collector = Set.new

    calculation.arcs.each do |arc|
      get_all_items(collector, arc)  
    end

    expected=%w{loc_ComprehensiveIncomeNetOfTaxIncludingPortionAttributableToNoncontrollingInterest_19
              loc_OtherComprehensiveIncomeDefinedBenefitPlansAdjustmentNetOfTaxPortionAttributableToParent_19
              loc_OtherComprehensiveIncomeForeignCurrencyTransactionAndTranslationGainLossBeforeReclassificationAndTax_19
              loc_ProfitLoss_19
              loc_OtherComprehensiveIncomeDerivativesQualifyingAsHedgesNetOfTaxPeriodIncreaseDecrease_19}
    assert_equal(expected.sort, collector.to_a.sort)
  end

  def get_all_items(collector, arc)
    collector << arc.item_id
    arc.children.each do |child|
      get_all_items(collector, child)
    end unless arc.children.nil?
  end

end