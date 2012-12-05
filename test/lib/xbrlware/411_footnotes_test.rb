require File.dirname(__FILE__) + '/../../test_helper.rb'
class TestFootNotes < Test::Unit::TestCase
  @@xsd_file=File.dirname(__FILE__)+"/resources/us_gaap_schema_local.xsd"

  def setup
    xml_file=File.dirname(__FILE__)+"/resources/411/411_footnotes.xml"
    XbrlTest::SchemaValidator.validate(xml_file, @@xsd_file)
    @xbrl = Xbrlware::Instance.new(xml_file)
  end

  def test_get_all_notes
    itemid_notes=@xbrl.footnotes
    expected_items=["fnid_667467_1005_80000001", "fnid_667467_9004_70000023", "fnid_667467_4005_80000003"]
    assert_equal(expected_items.sort, itemid_notes.keys.sort)
    
    assert_equal(2, itemid_notes["fnid_667467_1005_80000001"]["en-US"].size)
    assert_equal(1, itemid_notes["fnid_667467_1005_80000001"]["de"].size)
    
    assert_equal(1, itemid_notes["fnid_667467_4005_80000003"]["en-US"].size)
    
    assert_equal(2, itemid_notes["fnid_667467_9004_70000023"]["en-US"].size)
  end
  
  def test_get_notes_for_a_item
    lang_notes=@xbrl.footnotes("fnid_667467_1005_80000001")
    assert_equal(2, lang_notes.keys.size)

    assert_equal(2, lang_notes["en-US"].size)
    assert_equal(1, lang_notes["de"].size)
    
    lang_notes=@xbrl.footnotes("not_exist")
    assert_nil(lang_notes)
    
  end
  
  def test_get_notes_for_a_item_and_lang
    notes=@xbrl.footnotes("fnid_667467_1005_80000001", "en-US")
    assert_equal(2, notes.size)
    
    notes=@xbrl.footnotes("fnid_667467_1005_80000001", "de")
    assert_equal(1, notes.size)
    
    notes=@xbrl.footnotes("fnid_667467_1005_80000001", "fr")
    assert_nil(notes)
  end
  
  def test_exception_when_item_id_is_nil_and_lang_is_not_nil
    begin
      @xbrl.footnotes(nil, "en-US")
      fail
    rescue Exception=> e
    end
  end
  
  def test_xbrl_item_has_footnotes
    items=@xbrl.item("StockholdersEquity")
    assert_equal(1, items.size)
    assert_equal(2, items[0].footnotes["en-US"].size)
    
    items=@xbrl.item("SalesRevenueGoodsNet")
    assert_equal(1, items.size)
    assert_nil(items[0].footnotes)
    
  end
end