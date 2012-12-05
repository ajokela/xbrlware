require File.dirname(__FILE__) + '/../../../test_helper.rb'

class TestLinkbase < Test::Unit::TestCase
  
  
  def test_build_relationship
    a=Xbrlware::Linkbase::Linkbase::Link::Arc.new("a", "href_for_a")
    b=Xbrlware::Linkbase::Linkbase::Link::Arc.new("b", "href_for_b")
    c=Xbrlware::Linkbase::Linkbase::Link::Arc.new("c", "href_for_c")
    d=Xbrlware::Linkbase::Linkbase::Link::Arc.new("d", "href_for_d")
    e=Xbrlware::Linkbase::Linkbase::Link::Arc.new("e", "href_for_e")
    f=Xbrlware::Linkbase::Linkbase::Link::Arc.new("f", "href_for_f")
    z=Xbrlware::Linkbase::Linkbase::Link::Arc.new("z", "href_for_z")
    o=Xbrlware::Linkbase::Linkbase::Link::Arc.new("o", "href_for_o")
    p=Xbrlware::Linkbase::Linkbase::Link::Arc.new("p", "href_for_p")
    q=Xbrlware::Linkbase::Linkbase::Link::Arc.new("q", "href_for_q")
    
    a_1=Xbrlware::Linkbase::Linkbase::Link::Arc.new("a", "href_for_a")
    
    map={a_1 => [b, c, d], b => e, c => f, f => [o, p, q], z => a}
    
    arcs=Xbrlware::Linkbase::Linkbase.build_relationship(map)
    assert_equal(1, arcs.size)
    assert_equal("z", arcs[0].item_id)
    assert_equal(1, arcs[0].children.size)
    
    a_=arcs[0].children.select {|s| s==a}
    assert_equal(3, a_[0].children.size)
    
    c_=a_[0].children.select {|s| s==c}
    assert_equal(1, c_[0].children.size)
    
    f_=c_[0].children.select {|s| s==f}
    assert_equal(3, f_[0].children.size)
  end
end