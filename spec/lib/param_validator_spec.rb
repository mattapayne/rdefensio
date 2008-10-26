require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe RDefensio::ParamValidator do
  
  def configure(opts={})
    options = default_settings.merge(opts)
    RDefensio::API.configure do |c|
      c.api_key = options[:api_key]
      c.owner_url = options[:owner_url]
      c.format = options[:format]
      c.service_type = options[:service_type]
    end
  end
  
  def default_settings
    {
      :api_key => "sdffsdfdfsdfsdf",
      :owner_url => "http://test.ca/blog",
      :format => "yaml",
      :service_type => "blog"
    }
  end
  
  describe "valid?" do
  
    after(:each) do
      RDefensio::API.configure do |c|
        c.api_key = nil
        c.owner_url = nil
        c.format = nil
        c.service_type = nil
      end
    end
    
    it "should return false if the owner_url is not set" do
      configure(:owner_url => nil)
      RDefensio::ParamValidator.valid?(RDefensio::API).should be_false
    end
    
    it "should return false if the api_key is not set" do
      configure(:api_key => nil)
      RDefensio::ParamValidator.valid?(RDefensio::API).should be_false
    end
    
    it "should return false if the owner_url is an invalid url" do
      configure(:owner_url => "fsdfdsddf")
      RDefensio::ParamValidator.valid?(RDefensio::API).should be_false
    end
    
    it "should return false if the format is invalid" do
      configure(:format => "")
      RDefensio::ParamValidator.valid?(RDefensio::API).should be_false
    end
    
    it "should return false if the service type is invalid" do
      configure(:service_type => "")
      RDefensio::ParamValidator.valid?(RDefensio::API).should be_false
    end
    
    it "should return true if all values are properly set" do
      configure()
      RDefensio::ParamValidator.valid?(RDefensio::API).should be_true
    end
    
  end
  
  describe "required_params_present?" do
    
    it "should raise an exception if the required fields parameter is nil" do
      lambda {
        RDefensio::ParamValidator.required_params_present?({:test => 1}, nil)
      }.should raise_error
    end
    
    it "should raise an exception if the object data parameter is nil" do
      lambda {
        RDefensio::ParamValidator.required_params_present?(nil, [:test])
      }.should raise_error
    end
    
    it "should raise an exception if the object data parameter is empty" do
      lambda {
        RDefensio::ParamValidator.required_params_present?({}, [:test])
      }.should raise_error
    end
    
    it "should raise an exception if one or more required parameters are missing" do
      lambda {
        RDefensio::ParamValidator.required_params_present?({:monkey => "butler"}, [:test, :monkey])
      }.should raise_error
    end
    
    it "should not raise an exception if all required parameters are present" do
      lambda {
        RDefensio::ParamValidator.required_params_present?({
            :monkey => "butler", :test => "x"}, [:test, :monkey])
      }.should_not raise_error
    end

  end
  
end