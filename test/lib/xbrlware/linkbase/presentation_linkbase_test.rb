require File.dirname(__FILE__) + '/../../../test_helper.rb'
require File.dirname(__FILE__) + '/linkbase_test_util'


class TestPresentationLinkbase < Test::Unit::TestCase
  include LinkbaseTestUtil 
  def setup
    label_file=File.dirname(__FILE__)+"/resources/lab.xml"    
    label_linkbase = Xbrlware::Linkbase::LabelLinkbase.new(label_file)
    
    def_file=File.dirname(__FILE__)+"/resources/def.xml"    
    def_linkbase = Xbrlware::Linkbase::DefinitionLinkbase.new(def_file, label_linkbase)
    
    pre_file=File.dirname(__FILE__)+"/resources/pre.xml"    
    instance_file=File.dirname(__FILE__)+"/resources/instance.xml"
    instance = Xbrlware::Instance.new(instance_file)
    @pre_linkbase = Xbrlware::Linkbase::PresentationLinkbase.new(pre_file, instance, def_linkbase.definition, label_linkbase)
  end
  
  def test_presentation
    presentation=@pre_linkbase.presentation
    assert_equal(22, presentation.size)

    presentation=@pre_linkbase.presentation("http://pbg.com/20090613/role/StatementsOfChangesInEquityParenthetical")
    assert_not_nil(presentation)
    assert_equal("StatementsOfChangesInEquityParenthetical", presentation.href)


    presentation=@pre_linkbase.presentation("not-exist")
    assert_nil(presentation)
  end
end