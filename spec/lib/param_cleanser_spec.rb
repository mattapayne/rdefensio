require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe RDefensio::ParamCleanser do
  
  describe "cleanup!" do
    
    it "should return nil if the object data passed in is nil" do
      RDefensio::ParamCleanser.cleanup!(nil, []).should be_nil
    end
    
    it "should return nil if the object data passed in is empty" do
      RDefensio::ParamCleanser.cleanup!({}, []).should be_nil
    end
    
    it "should remove all entries from object data where the values are nil" do
      od = {:a => nil, :b => "stuff", :c => "other"}
      RDefensio::ParamCleanser.cleanup!(od, [:a, :b, :c]).should have(2).items
    end
    
    it "should remove all entries from the object data where the values are empty" do
      od = {:a => "", :b => "stuff", :c => "other"}
      RDefensio::ParamCleanser.cleanup!(od, [:a, :b, :c]).should have(2).items
    end
    
    it "should remove all entries from the object data that are not valid parameters" do
      od = {:a => "monkey", :b => "stuff", :c => "other"}
      RDefensio::ParamCleanser.cleanup!(od, [:a, :b]).should have(2).items
    end
    
  end
  
end