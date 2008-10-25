require 'test/unit'
require File.join(File.dirname(__FILE__), "..", "lib", "poster")

class PosterTest < Test::Unit::TestCase
  
  def setup
    @poster = RDefensio::Poster.new("http://www.test.ca")
  end
  
  def teardown
    @poster = nil
  end
  
  def test_it_should_raise_an_exception_if_no_base_url_specified
    assert_raise RDefensio::PosterException do
      RDefensio::Poster.new(nil)
    end
  end
  
  def test_it_should_raise_an_exception_if_the_path_is_nil
    assert_raise RDefensio::PosterException do
      @poster.post(nil, {"a" => "value"})
    end
  end
  
  def test_it_should_raise_an_exception_if_the_path_is_empty
    assert_raise RDefensio::PosterException do
      @poster.post(String.new, {"a" => "value"})
    end
  end
  
  def test_it_should_raise_an_exception_if_the_post_data_is_nil
    assert_raise RDefensio::PosterException do
      @poster.post("action", nil)
    end
  end
  
  def test_it_should_raise_an_exception_if_the_post_data_is_empty
    assert_raise RDefensio::PosterException do
      @poster.post("action", {})
    end
  end
  
end
