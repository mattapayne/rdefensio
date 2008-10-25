require 'rexml/document'
require 'rexml/xpath'
      
module RDefensio
  
  class XmlParser < Parser
    
    def initialize(data)
      super
    end
    
    def parse
      return {} if (data.nil? || data.empty?)
      doc = REXML::Document.new(data)
      data = {}
      REXML::XPath.each(doc.root) {|element| data[element.name.gsub("-", "_")] = element.text }
      return data
    end

  end

end