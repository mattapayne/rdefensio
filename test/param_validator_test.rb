require 'test/unit'
require File.join(File.dirname(__FILE__), "..", "lib", "constants")
require File.join(File.dirname(__FILE__), "..", "lib", "param_validator")

class ParamCleanserTest < Test::Unit::TestCase
  
  def test_it_should_return_true_if_url_valid
    url = "http://test.ca"
    assert_equal(true, RDefensio::ParamValidator.send(:url_valid?, url))
  end
  
  def test_it_should_return_false_if_url_not_valid
    url = "http://test/ca"
    assert_equal(false, RDefensio::ParamValidator.send(:url_valid?, url))
  end
  
  def test_it_should_raise_an_exception_if_the_object_hash_is_nil
    assert_raise RDefensio::ParamValidationException do
      RDefensio::ParamValidator.send(:required_params_present?, nil, ["blah"])
    end 
  end
  
  def test_it_should_raise_an_exception_if_the_object_hash_is_empty
    assert_raise RDefensio::ParamValidationException do
      RDefensio::ParamValidator.send(:required_params_present?, {}, ["blah"])
    end 
  end
  
  def test_it_should_raise_an_exception_if_the_required_array_is_nil
    assert_raise RDefensio::ParamValidationException do
      RDefensio::ParamValidator.send(:required_params_present?, {"stuff" => "other stuff"}, nil)
    end 
  end
  
  def test_it_should_raise_an_exception_if_one_or_more_fields_specified_in_required_are_missing_from_object_hash
    assert_raise RDefensio::ParamValidationException do
      RDefensio::ParamValidator.send(:required_params_present?, {"nothing" => "Blah"}, ["something"])
    end
  end
  
  def test_it_should_not_raise_an_exception_if_all_fields_specified_in_required_are_present_in_object_hash
    assert_nothing_raised do
      RDefensio::ParamValidator.send(:required_params_present?, {"nothing" => "Blah", "something" => "x"}, ["something", "nothing"])
    end
  end
  
end