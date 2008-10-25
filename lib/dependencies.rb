local_dir = File.dirname(__FILE__)
[
  'constants', 
  'param_validator', 
  'param_cleanser', 
  'poster', 
  'parser', 
  'yaml_parser', 
  'xml_parser'
].each do |f|
  require File.join(local_dir, f)
end
require 'cgi'
require 'ostruct'
require 'date'
