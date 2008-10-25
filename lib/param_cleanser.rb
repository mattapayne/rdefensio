module RDefensio
  
  class ParamCleanser
  
    private_class_method(:new)
      
    def self.cleanup!(object_data, keys)
      return if object_data.nil? || object_data.empty?
      #Remove nil and blank values
      keys.each {|k| object_data.delete(k) if object_data[k].nil? || object_data[k].empty?}
      #Remove parameters that should not be here
      object_data.reject! { |key,value| !keys.include?(key)  }
      object_data
    end
    
  end
  
end
