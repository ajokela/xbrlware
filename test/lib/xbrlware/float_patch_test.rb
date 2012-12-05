require File.dirname(__FILE__) + '/../../test_helper.rb'
class TestFloatPatch < Test::Unit::TestCase
  def test_round_at
    x=10.1234561
    assert_equal(x.round_at(3), 10.123)
    assert_equal(x.round_at(4), 10.1235)
    assert_equal(x.round_at(5), 10.12346)
    assert_equal(x.round_at(6), 10.123456)
  end
end