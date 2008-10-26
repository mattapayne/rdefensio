spec = Gem::Specification.new do |s|
  s.name = 'rdefensio'
  s.version = '1.0'
  s.summary = "Defensio library."
  s.description = %{A Ruby Defensio library use to access the Defensio API.}
  s.files = Dir['lib/**/*.rb'] + Dir['spec/**/*.rb']
  s.require_path = 'lib'
  s.autorequire = 'rdefensio'
  s.has_rdoc = false
  s.author = "Matt Payne"
  s.email = "paynmatt@gmail.com"
  s.homepage = "http://mattpayne.ca"
end

