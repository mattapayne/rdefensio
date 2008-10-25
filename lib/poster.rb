require 'net/http'
require 'uri'

module RDefensio
  
  class PosterException < RuntimeError
    
    def initialize(msg)
      super
    end
    
  end
    
  class Poster
  
    def initialize(base_url)
      raise PosterException.new("The base url must be specified") if (base_url.nil? || base_url.empty?)
      @base_url = base_url
    end
  
    def post(path, data)
      raise PosterException.new("Path cannot be nil or empty.") if (path.nil? || path.empty?)
      raise PosterException.new("Data to post cannot be nil or empty.") if (data.nil? || data.empty?)
      return http.post(path, data)
    end
  
    private
  
    def http
      return Net::HTTP.new(@base_url)
    end
  
  end
  
end