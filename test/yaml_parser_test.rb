require 'test/unit'
require File.join(File.dirname(__FILE__), "..", "lib", "parser")
require File.join(File.dirname(__FILE__), "..", "lib", "yaml_parser")

class YamlParserTest < Test::Unit::TestCase
  
  def setup
    @data = {"defensio-result" => {"message" => "msg", "status" => "status", "api-version" => "1.2"}}.to_yaml
  end
  
  def test_it_should_convert_the_data_into_a_hash
    parser = RDefensio::YamlParser.new(@data)
    result = parser.parse
    assert_instance_of(Hash, result)
    assert_equal("msg", result["message"])
    assert_equal("status", result["status"]) 
    assert_equal("1.2", result["api_version"])     
  end
  
  def test_it_should_raise_an_exception_if_the_data_to_parse_is_nil
    assert_raise RDefensio::ParserException do
      RDefensio::YamlParser.new(nil)
    end 
  end
  
  def test_it_should_raise_an_exception_if_the_data_to_parse_is_empty
    assert_raise RDefensio::ParserException do
      RDefensio::YamlParser.new(String.new)
    end 
  end
  
end
