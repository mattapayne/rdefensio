require 'yaml'

module RDefensio
  
  class YamlParser < Parser
  
    def initialize(data)
      super
    end
    
    def parse
      tmp = YAML.load(data)["defensio-result"]
      return tmp.inject({}) do |h, (k,v)|
        h[k.gsub("-", "_")] = v
        h
      end
    end

  end

end
