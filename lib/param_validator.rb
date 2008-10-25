module RDefensio
  
  class ParamValidationException < RuntimeError
    
    def initialize(msg)
      super
    end
    
  end
    
  class ParamValidator
  
    private_class_method(:new)
  
    def self.valid?(rdefensio)
      !rdefensio.api_key.nil? && !rdefensio.api_key.empty? && 
        !rdefensio.owner_url.nil? && !rdefensio.owner_url.empty? && 
        url_valid?(rdefensio.owner_url) &&
        Constants::SERVICE_TYPES.include?(rdefensio.service_type) &&
        Constants::FORMATS.include?(rdefensio.format)
    end
  
    def self.required_params_present?(object_hash, required)
      raise ParamValidationException.new("Required fields cannot be nil.") if required.nil?
      raise ParamValidationException.new( 
        "The object hash cannot be nil or empty.") if (object_hash.nil? || object_hash.empty?)
      errors = required.inject([]) do |arr, req|
        arr << "#{req} is a required parameter." unless object_hash.key?(req)
        arr
      end
      raise ParamValidationException.new( 
        errors.join(", ")) unless (errors.nil? || errors.empty?)
    end
  
    private
  
    def self.url_valid?(url)
      return ((Constants::URL_REGEX =~ url) != nil)
    end
  
  end
  
end
