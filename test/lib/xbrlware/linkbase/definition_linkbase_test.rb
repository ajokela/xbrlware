require File.dirname(__FILE__) + '/../../../test_helper.rb'
require File.dirname(__FILE__) + '/linkbase_test_util'

class TestDefinitionLinkbase < Test::Unit::TestCase
  include LinkbaseTestUtil 
  
  def test_definition
    def_file=File.dirname(__FILE__)+"/resources/def_with_multiple_dimension.xml"
    def_linkbase = Xbrlware::Linkbase::DefinitionLinkbase.new(def_file)
    definition=def_linkbase.definition[0]
    assert_equal("Guarantees", definition.href)    
    assert_equal(1, definition.primary_items.size)
    assert_equal(1, definition.primary_items.to_a[0].hypercubes.size)
    assert_equal(2, definition.primary_items.to_a[0].hypercubes.to_a[0].dimensions.size)
    
    dimensions=definition.primary_items.to_a[0].hypercubes.to_a[0].dimensions.to_a
    assert_equal(1, dimensions[0].domains.size)
    domain_prods=dimensions[0].domains.to_a
    assert_equal("company_AllRegions_0", domain_prods[0].item_id)
    assert_equal(4, domain_prods[0].members.size)
    
    
    assert_equal(1, dimensions[1].domains.size)
    domain_regions=dimensions[1].domains.to_a
    assert_equal("company_AllProducts_0", domain_regions[0].item_id)
    assert_equal(4, domain_regions[0].members.size)
  end
  
  def test_invalid_definition
    def_file=File.dirname(__FILE__)+"/resources/def_with_multiple_dimension.xml"
    def_linkbase = Xbrlware::Linkbase::DefinitionLinkbase.new(def_file)
    definition=def_linkbase.definition("role_not_exist")
    assert_nil(definition)
  end
end