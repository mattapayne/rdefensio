require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe RDefensio::XmlParser do
  
  before(:each) do
    @parser = RDefensio::XmlParser.new(File.open(File.join(File.dirname(__FILE__), "..", "response.xml"), "r").read)
  end
  
  it "should construct a REXML::Document object using the data" do
    doc = REXML::Document.new(@parser.data)
    REXML::Document.should_receive(:new).with(@parser.data).and_return(doc)
    @parser.parse
  end
  
  it "should replace all dashes with underscores on element names" do
    result = @parser.parse
    result.keys.each {|k| k.to_s.should_not include("-")}
  end
  
end