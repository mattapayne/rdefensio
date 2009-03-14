#The GemSpec to build the gem
Gem::Specification.new do |s|
  s.name = 'rdefensio'
  s.version = '1.0.1'
  s.date = "2009-03-14"
  s.summary = "Defensio library."
  s.description = %{A Ruby Defensio library use to access the Defensio API.}
  s.has_rdoc = false
  s.author = "Matt Payne"
  s.email = "paynmatt@gmail.com"
  s.homepage = "http://mattpayne.ca"
  s.files = [
    'README', 'rdefensio.gemspec', 'lib/constants.rb', 'lib/dependencies.rb',
    'lib/param_cleanser.rb', 'lib/param_validator.rb', 'lib/parser.rb',
    'lib/poster.rb', 'lib/rdefensio.rb', 'lib/xml_parser.rb', 'lib/yaml_parser.rb'
  ]
  s.test_files = [
    'spec/spec_helper.rb', 'spec/response.xml', 'spec/response.yml', 
    'spec/lib/param_cleanser_spec.rb', 'spec/lib/param_validator.rb',
    'spec/lib/parser_spec.rb', 'spec/lib/poster_spec.rb', 'spec/lib/rdefensio_spec.rb',
    'spec/lib/xml_parser_spec.rb', 'spec/lib/yaml_parser_spec.rb'
  ]
end
