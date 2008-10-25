require 'test/unit'
require File.join(File.dirname(__FILE__), "..", "lib", "parser")
require File.join(File.dirname(__FILE__), "..", "lib", "xml_parser")

class XmlParserTest < Test::Unit::TestCase
  
  def setup
    @data = File.open("response.xml", "r").read
  end
  
  def test_it_should_convert_the_data_into_a_hash
    parser = RDefensio::XmlParser.new(@data)
    result = parser.parse
    assert_instance_of(Hash, result)
    assert_equal("msg", result["message"])
    assert_equal("status", result["status"]) 
    assert_equal("1.2", result["api_version"])     
  end
  
  def test_it_should_raise_an_exception_if_the_data_to_parse_is_nil
    assert_raise RDefensio::ParserException do
      RDefensio::XmlParser.new(nil)
    end 
  end
  
  def test_it_should_raise_an_exception_if_the_data_to_parse_is_empty
    assert_raise RDefensio::ParserException do
      RDefensio::XmlParser.new(String.new)
    end 
  end
  
end
