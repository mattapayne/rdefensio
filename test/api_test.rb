require 'test/unit'
require File.join(File.dirname(__FILE__), "..", "lib", "rdefensio")

class RDefensioTest < Test::Unit::TestCase
  
  class MockPoster
    
    def post(path, data)
      
    end
    
  end
  
  def setup
    RDefensio::API.configure do |conf|
      conf.api_key = "mykey"
      conf.owner_url = "http://blog.test.ca"
    end
  end
  
  def teardown
    RDefensio::API.configure do |conf|
      conf.api_key = nil
      conf.owner_url = nil
    end
  end
  
  def test_should_raise_exception_if_instantiation_attempted
    assert_raise NoMethodError do
      RDefensio::API.new
    end 
  end
  
  #API methods------------------------------------------------------------------
  
  
  #Configuration ---------------------------------------------------------------
  
  def test_should_not_be_valid_if_api_key_not_set
    RDefensio::API.configure do |conf|
      conf.api_key = nil
    end
    assert_equal(false, RDefensio::API.valid?)
  end
  
  def test_it_should_be_possible_to_set_poster_to_another_class
    RDefensio::API.configure do |c|
      c.poster = MockPoster.new
    end
    assert_instance_of(MockPoster, RDefensio::API.poster) 
  end
  
  def test_should_not_be_valid_if_owner_url_not_set
    RDefensio::API.configure do |conf|
      conf.owner_url = nil
    end
    assert_equal(false, RDefensio::API.valid?)
  end
  
  def test_should_not_be_valid_if_format_is_invalid
    RDefensio::API.configure do |conf|
      conf.format = "Something"
    end
    assert_equal(false, RDefensio::API.valid?)
  end
  
  def test_should_not_be_valid_if_service_type_is_invalid
    RDefensio::API.configure do |conf|
      conf.service_type = "Something"
    end
    assert_equal(false, RDefensio::API.valid?)
  end
  
  def test_should_be_valid_if_api_key_is_set
    assert_equal(true, RDefensio::API.valid?)
  end
  
  def test_should_raise_exception_if_configure_not_given_a_block
    assert_raise RDefensio::RDefensioException do
      RDefensio::API.configure()
    end 
  end
  
  #--------------------CREATE URL-----------------------------------------------
  
  def test_it_should_raise_an_exception_if_the_is_not_specified
    assert_raise RDefensio::RDefensioException do
      RDefensio::API.send(:create_url, nil)
    end 
  end
  
  def test_it_should_formulate_the_correct_url_with_the_correct_action
    expected = "/blog/1.2/report-false-positives/mykey.yaml"
    assert_equal(expected, RDefensio::API.send(:create_url, "report-false-positives")) 
  end
  
  #----------------------CREATE_POST_DATA---------------------------------------
  
  def test_it_should_properly_create_a_post_data_string
    h = {"test" => "monkey", "test2" => "mojo"}
    actual = RDefensio::API.send(:create_post_data, h)
    assert_equal(true, actual.include?("test=monkey"))
    assert_equal(true, actual.include?("test2=mojo"))
  end
  
  def test_it_should_url_encode_post_data_string
    h = {"test" => "<monkey>", "test2" => "&mojo&"}
    actual = RDefensio::API.send(:create_post_data, h)
    assert_equal(true, actual.include?("test2=%26mojo%26"))
    assert_equal(true, actual.include?("test=%3Cmonkey%3E"))
  end
  
  #----------------------PREPARE DATE-------------------------------------------
  
  def test_it_should_properly_convert_a_date_string
    data = "10/21/2008"
    actual = RDefensio::API.send(:prepare_date, data)
    assert_equal("2008/10/21", actual)
  end
  
  def test_it_should_properly_convert_a_date_object
    data = Date.parse("10/21/2008")
    actual = RDefensio::API.send(:prepare_date, data)
    assert_equal("2008/10/21", actual) 
  end
  
  def test_it_should_return_nil_if_date_passed_in_is_nil
    actual = RDefensio::API.send(:prepare_date, nil)
    assert_nil(actual)
  end
  
  #-----------------------POST TO DEFENSIO----------------------------------------------
  
  def test_it_should_raise_an_exception_if_the_action_is_not_specified
    assert_raise RDefensio::RDefensioException do
      RDefensio::API.send(:post_to_defensio, nil, {"owner_url" => "something"})
    end 
  end
  
  def test_it_should_raise_an_exception_if_the_post_data_is_nil
    assert_raise RDefensio::RDefensioException do
      RDefensio::API.send(:post_to_defensio, 'get-stats', nil)
    end 
  end
  
  def test_it_should_raise_an_exception_if_the_post_data_is_empty
    assert_raise RDefensio::RDefensioException do
      RDefensio::API.send(:post_to_defensio, 'get-stats', {})
    end 
  end
  
  def test_it_should_raise_an_exception_if_the_action_is_not_valid
    assert_raise RDefensio::RDefensioException do
      RDefensio::API.send(:post_to_defensio, 'something', {})
    end 
  end
  
end
