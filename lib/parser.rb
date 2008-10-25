module RDefensio
  
  class ParserException < RuntimeError
    
    def initialize(msg)
      super
    end
  end
  
  class Parser
    
    attr_reader :data
    
    def initialize(data)
      raise ParserException.new("The data to parse cannot be nil or empty.") if (data.nil? || data.empty?)
      @data = data
    end
    
    def parse
      return nil
    end
    
  end
  
end
