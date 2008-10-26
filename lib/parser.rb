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
      raise ParserException.new("This is an abstract method. Please call this on a subclass.")
    end
    
  end
  
end
