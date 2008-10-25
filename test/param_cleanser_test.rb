require 'test/unit'
require File.join(File.dirname(__FILE__), "..", "lib", "param_cleanser")

class ParamCleanserTest < Test::Unit::TestCase
  
    def test_cleanup_removes_all_entries_that_have_nil_or_empty_values
    object_hash = {"monkey" => "OK", "butler" => "", "mojo" => nil}
    result = RDefensio::ParamCleanser.send(:cleanup!, object_hash, ["monkey", "butler", "mojo"])
    assert_equal({"monkey" => "OK"}, result)
  end
  
  def test_cleanup_removes_all_entries_that_are_not_included_in_the_allowed_fields
    object_hash = {"monkey" => "OK", "butler" => "mojo", "mojo" => nil}
    result = RDefensio::ParamCleanser.send(:cleanup!, object_hash, ["monkey", "butler"])
    assert_equal({"monkey" => "OK", "butler" => "mojo"}, result)
  end
  
end
