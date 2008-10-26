require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe RDefensio::Parser do
  
  it "should raise an exception if constructed without data" do
    lambda {
      RDefensio::Parser.new(nil)
    }.should raise_error
  end
  
  it "should raise an exception when asked to parse" do
    parser = RDefensio::Parser.new({"rdefensio-result" => {"stuff" => "stuff"}})
    lambda {
      parser.parse
    }.should raise_error
  end
  
end