require File.dirname(__FILE__) + '/../../test_helper.rb'
class TestHashUtil < Test::Unit::TestCase
  def test_hash_to_object
    h={"address"=>{"office"=>{"city"=>"NY"}, "home"=>{"city"=>"NJ", "route"=>["10E", "S", "R"]}}, "name"=>"selvan", "age"=>20, "route"=>["L", "25W", "E"]}
    o=Xbrlware::HashUtil::to_obj(h)

    assert_equal("selvan", o.name)
    assert_equal(["L", "25W", "E"], o.route)
    assert_equal(20, o.age)
    assert_equal("NY", o.address.office.city)
    assert_equal("NJ", o.address.home.city)
    assert_equal(["10E", "S", "R"], o.address.home.route)
  end

  def test_ordered_hash
    h=Xbrlware::HashUtil::OHash.new()
    h["address"]="some-address"
    h["name"]="some-name"
    h["age"]=20
    h["route"]="some-route"

    assert_equal("address", h.keys[0])
    assert_equal("name", h.keys[1])
    assert_equal("age", h.keys[2])
    assert_equal("route", h.keys[3])

    assert(h.instance_of?(Hash))
  end
end