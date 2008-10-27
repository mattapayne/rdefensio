require 'rubygems'
require File.join(File.dirname(__FILE__), "..", "lib", "rdefensio")
require 'spec'
require 'spec/interop/test'

def xml_response
  @xml ||= File.open(File.join(File.dirname(__FILE__), "response.xml"), "r").read
end

def yaml_response
  @yaml ||= File.open(File.join(File.dirname(__FILE__), "response.yml"), "r").read
end