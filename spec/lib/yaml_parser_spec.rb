require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe RDefensio::YamlParser do
  
  before(:each) do
    @parser = RDefensio::YamlParser.new(File.open(File.join(File.dirname(__FILE__), "..", "response.yml"), "r").read)
  end
  
  it "should construct a hash using YAML.load using the data" do
    original_data = YAML.load(@parser.data)
    YAML.should_receive(:load).with(@parser.data).and_return(original_data)
    @parser.parse
  end
  
  it "should replace all dashes with underscores on element names" do
    result = @parser.parse
    result.keys.each {|k| k.to_s.should_not include("-")}
  end
  
  it "should return a hash" do
    @parser.parse.should be_is_a(Hash)
  end
  
end