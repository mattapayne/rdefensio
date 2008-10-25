local_dir = File.dirname(__FILE__)
['param_cleanser_test', 'param_validator_test', 'poster_test', 'api_test',
  'yaml_parser_test', 'xml_parser_test'].each do |f|
  require File.join(local_dir, f)
end

