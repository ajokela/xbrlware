require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestXbrlTaxonomy < Test::Unit::TestCase

  @@xsd_file=File.dirname(__FILE__)+"/resources/us_gaap_schema_local.xsd"

  def test_linkbase_files_are_pickedup_from_taxomony
    taxonomy_file=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/taxonomy.xsd"
    taxonomy=Xbrlware::Taxonomy.new(taxonomy_file, nil)
    taxonomy.init_all_lb

    assert_not_nil(taxonomy.lablb)
    assert_not_nil(taxonomy.prelb)
    assert_not_nil(taxonomy.deflb)
    assert_not_nil(taxonomy.callb)

    taxonomy_file=File.dirname(__FILE__)+"/resources/taxonomy_test_files/2/taxonomy.xsd"
    taxonomy=Xbrlware::Taxonomy.new(taxonomy_file, nil)
    taxonomy.init_all_lb

    assert_not_nil(taxonomy.lablb)
    assert_not_nil(taxonomy.prelb)
    assert_not_nil(taxonomy.deflb)
    assert_not_nil(taxonomy.callb)
  end

  def test_linkbase_files_from_taxonomy_are_ignored_when_overriden
    taxonomy_file=File.dirname(__FILE__)+"/resources/taxonomy_test_files/3/taxonomy.xsd"
    taxonomy=Xbrlware::Taxonomy.new(taxonomy_file, nil)

    _cal=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/cal.xml"
    _pre=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/pre.xml"
    _lab=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/lab.xml"
    _def=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/def.xml"

    taxonomy.init_all_lb(_cal, _pre, _lab, _def)

    assert_not_nil(taxonomy.lablb)
    assert_not_nil(taxonomy.deflb)
    assert_not_nil(taxonomy.prelb)
    assert_not_nil(taxonomy.callb)
  end

  def test_linbase_files_are_initialized_only_once
    taxonomy_file=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/taxonomy.xsd"
    taxonomy=Xbrlware::Taxonomy.new(taxonomy_file, nil)
    taxonomy.init_all_lb

    _cal=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/not_exist_cal.xml"
    _pre=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/not_exist_pre.xml"
    _lab=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/not_exist_lab.xml"
    _def=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/not_exist_def.xml"

    taxonomy.init_all_lb(_cal, _pre, _lab, _def)

    assert_not_nil(taxonomy.lablb)
    assert_not_nil(taxonomy.prelb)
    assert_not_nil(taxonomy.deflb)
    assert_not_nil(taxonomy.callb)
  end


  def test_taxonomy_definition
    taxonomy_file=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/taxonomy.xsd"
    taxonomy=Xbrlware::Taxonomy.new(taxonomy_file, nil)

    assert_not_nil(taxonomy.definition("BalanceSheetDetailsAbstract"))

    #elemnt that has dash in the name
    assert_not_nil(taxonomy.definition("Owners-NetInvestment-Member"))

    #element name has special chars
    assert_not_nil(taxonomy.definition("Owners$Net.Investment|Member"))
  end

  def test_predefined_us_gaap_taxonomy_definition
    taxonomy_file=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/taxonomy.xsd"
    taxonomy=Xbrlware::Taxonomy.new(taxonomy_file, nil)
    assert_not_nil(taxonomy.definition("AccidentAndHealthInsuranceSegmentMember"))
  end
end

class TestXbrlTaxonomyForNewDefinition < Test::Unit::TestCase

  def setup
    @_t_name=ENV["TAXO_NAME"]
    @_t_version=ENV["TAXO_VER"]
  end

  def teardown
    ENV["TAXO_NAME"]=@_t_name
    ENV["TAXO_VER"]=@_t_version
  end

  def test_introduce_new_taxonomy
    Xbrlware::Taxonomies.module_eval %{
      module NZGAAP2008
        def element_definition
          "element_value"
        end
      end
    }

    ENV["TAXO_NAME"]="NZ-GAAP"
    ENV["TAXO_VER"]="2008"

    tax_def=Xbrlware::Taxonomy.new(nil, nil)
    def_value=tax_def.definition("element_definition")
    assert_equal("element_value", def_value)

  end

  def test_invalid_taxonomy

    ENV["TAXO_NAME"]="IN-GAAP"
    ENV["TAXO_VER"]="2008"

    tax_def=Xbrlware::Taxonomy.new(nil, nil)
    def_value=tax_def.definition("element_definition")
    assert_nil(def_value)

  end

  def test_linkbase_files_are_ignored
    taxonomy_file=File.dirname(__FILE__)+"/resources/taxonomy_test_files/1/taxonomy.xsd"
    taxonomy=Xbrlware::Taxonomy.new(taxonomy_file, nil)
    taxonomy.ignore_lablb=true
    taxonomy.ignore_prelb=true
    taxonomy.ignore_deflb=true
    taxonomy.ignore_callb=true

    taxonomy.init_all_lb
    assert_nil(taxonomy.lablb)
    assert_nil(taxonomy.prelb)
    assert_nil(taxonomy.deflb)
    assert_nil(taxonomy.callb)

    taxonomy_file=File.dirname(__FILE__)+"/resources/taxonomy_test_files/2/taxonomy.xsd"
    taxonomy=Xbrlware::Taxonomy.new(taxonomy_file, nil)
    taxonomy.ignore_lablb=true
    taxonomy.ignore_prelb=true
    taxonomy.ignore_deflb=true
    taxonomy.ignore_callb=true
    taxonomy.init_all_lb

    assert_nil(taxonomy.lablb)
    assert_nil(taxonomy.prelb)
    assert_nil(taxonomy.deflb)
    assert_nil(taxonomy.callb)
  end

  def test_taxonomy_when_no_element_tags_present
    taxonomy_file=File.dirname(__FILE__)+"/resources/taxonomy_test_files/4/entry-point.xsd"
    taxonomy=Xbrlware::Taxonomy.new(taxonomy_file, nil)
    assert_not_nil(taxonomy)
  end

end
