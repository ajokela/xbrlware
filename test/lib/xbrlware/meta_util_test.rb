require File.dirname(__FILE__) + '/../../test_helper.rb'
class TestMetaUtil < Test::Unit::TestCase
  def test_introduce_instance_var
    o=Object.new
    Xbrlware::MetaUtil::introduce_instance_var(o, "name", "xyz")
    assert_equal("xyz", o.name)
  end

  def test_introduce_instance_writer
    o=Object.new
    Xbrlware::MetaUtil::introduce_instance_var(o, "name", "xyz")
    Xbrlware::MetaUtil::introduce_instance_writer(o, "set_name", "name")
    o.set_name="abc"
    assert_equal("abc", o.name)
  end

  def test_introduce_instance_alias
    o=Object.new
    Xbrlware::MetaUtil::introduce_instance_var(o, "name", "xyz")
    Xbrlware::MetaUtil::introduce_instance_alias(o, "get_name", "name")
    assert_equal("xyz", o.get_name)
  end

  def test_introduct_instance_method
    o="a"
    Xbrlware::MetaUtil::eval_on_instance o, %{
      def is_instant?
        self.is_a?(String)
      end

      def is_duration?
        self.is_a?(Hash)        
      end

      def is_forever?
        self.is_a?(Fixnum)
      end      
    }
    assert o.is_instant?
    assert_equal(false, o.is_duration?)
    assert_equal(false, o.is_forever?)
  end
end