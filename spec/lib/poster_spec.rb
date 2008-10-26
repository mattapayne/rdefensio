require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe RDefensio::Poster do
  
  it "should raise an exception if the base url is not specified at construction" do
    lambda{
      RDefensio::Post.new(nil)
    }.should raise_error
  end
  
  describe "post" do
  
    before(:all) do
      RDefensio::API.configure do |c|
        c.owner_url = "http://api.test.ca"
      end
    end
    
    before(:each) do
      @http_object = stub("HTTP Object")
      @http_object.stub!(:post)
      Net::HTTP.stub!(:new).with(RDefensio::API.owner_url).and_return(@http_object)
      @poster = RDefensio::Poster.new("http://api.test.ca")
    end
    
    it "should raise an exception if the path parameter is nil" do
      lambda {
        @poster.post(nil, "dfsddfg")
      }.should raise_error
    end
    
    it "should raise an exception if the path parameter is empty" do
      lambda {
        @poster.post("", "dfsddfg")
      }.should raise_error
    end
    
    it "should raise an exception if the data parameter is nil" do
      lambda {
        @poster.post("path", nil)
      }.should raise_error
    end
    
    it "should raise an exception if the data parameter is empty" do
      lambda {
        @poster.post("path", "")
      }.should raise_error
    end
    
    it "should pass the path and the data parameters to the http object" do
      @http_object.should_receive(:post).with("path", "abcdefg")
      @poster.post("path", "abcdefg")
    end
    
    it "should create a new instance of the Net::HTTP class" do
      Net::HTTP.should_receive(:new).with(RDefensio::API.owner_url).and_return(@http_object)
      @poster.post("path", "abcdefg")
    end
    
  end
  
end