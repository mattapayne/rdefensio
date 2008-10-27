require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe RDefensio::API do
    
  describe "configure" do
    
    it "should raise an exception if called without a block" do
      lambda {
        RDefensio::API.configure
      }.should raise_error
    end
    
    it "should provide a default for service_type if service_type is not set" do
      RDefensio::API.service_type.should == RDefensio::API::DEFAULT_SERVICE_TYPE
    end
    
    it "should provide a default for format if format is not set" do
      RDefensio::API.format.should == RDefensio::API::DEFAULT_FORMAT
    end
    
    it "should provide a default for api_version if api_version is not set" do
      RDefensio::API.api_version.should == RDefensio::API::DEFAULT_API_VERSION
    end
    
    it "should provide a default for poster if poster is not set" do
      RDefensio::API.poster.should be_is_a(RDefensio::Poster)
    end
    
  end
  
  describe "valid?" do
    
    it "should delegate to RDefensio::ParamValidator" do
      RDefensio::ParamValidator.should_receive(:valid?).with(RDefensio::API).and_return(true)
      RDefensio::API.valid?
    end
    
  end
  
  describe "API methods" do
    
    before(:each) do
      @yaml_response = stub("YAML Response", :body => yaml_response)
      @xml_response = stub("XML Response", :body => xml_response)
      @poster = mock(RDefensio::Poster, :post => @yaml_response)
      RDefensio::API.configure do |c|
        c.api_key = "dffdfsdfs"
        c.owner_url = "http://api.test.ca"
        c.poster = @poster
      end
    end
    
    after(:each) do
      RDefensio::API.configure do |c|
        c.api_key = nil
        c.owner_url = nil
        c.format = nil
        c.service_type = nil
        c.api_version = nil
      end
    end
    
    describe "post_to_defensio" do
      
      it 'should raise an exception if action is nil' do
        lambda {
          RDefensio.post_to_defensio(nil, {"test" => "test"})
        }.should raise_error
      end
      
      it 'should raise an exception if action is empty' do
        lambda {
          RDefensio.post_to_defensio("", {"test" => "test"})
        }.should raise_error
      end
      
      it 'should raise an exception if action is invalid' do
        lambda {
          RDefensio.post_to_defensio("invalid", {"test" => "test"})
        }.should raise_error
      end
      
      it 'should raise an exception if post data is nil' do
        lambda {
          RDefensio.post_to_defensio("get-stats", nil)
        }.should raise_error
      end
      
      it 'should raise an exception if post data is empty' do
        lambda {
          RDefensio.post_to_defensio("get-stats", {})
        }.should raise_error
      end
      
      it "should properly create an url for the specified action" do
        @poster.should_receive(:post).with("/blog/1.2/get-stats/dffdfsdfs.yaml", "owner-url=http%3A%2F%2Fapi.test.ca")
        RDefensio::API.post_to_defensio("get-stats", {"owner-url" => RDefensio::API.owner_url})
      end
      
      it "should properly set the correct format" do
        RDefensio::API.configure {|c| c.format = "xml"}
        @poster.should_receive(:post).
          with("/blog/1.2/get-stats/dffdfsdfs.xml", "owner-url=http%3A%2F%2Fapi.test.ca").
          and_return(@xml_response)
        RDefensio::API.post_to_defensio("get-stats", {"owner-url" => RDefensio::API.owner_url})
      end
      
      it "should properly set the correct service type" do
        RDefensio::API.configure {|c| c.service_type = "app"}
        @poster.should_receive(:post).
          with("/app/1.2/get-stats/dffdfsdfs.yaml", "owner-url=http%3A%2F%2Fapi.test.ca")
        RDefensio::API.post_to_defensio("get-stats", {"owner-url" => RDefensio::API.owner_url})
      end
      
      it "should properly set the correct api version" do
        RDefensio::API.configure {|c| c.api_version = "1.1"}
        @poster.should_receive(:post).
          with("/blog/1.1/get-stats/dffdfsdfs.yaml", "owner-url=http%3A%2F%2Fapi.test.ca")
        RDefensio::API.post_to_defensio("get-stats", {"owner-url" => RDefensio::API.owner_url})
      end
      
      it "should url encode the post data" do
        CGI.should_receive(:escape).exactly(2).times
        RDefensio::API.post_to_defensio("get-stats", {"owner-url" => RDefensio::API.owner_url})
      end
      
      it "should parse the response using the YamlParser if the format is set to yaml" do
        parser = mock("Yaml Parser", :parse => {})
        RDefensio::YamlParser.should_receive(:new).and_return(parser)
        parser.should_receive(:parse)
        RDefensio::API.post_to_defensio("get-stats", {"owner-url" => RDefensio::API.owner_url})
      end
      
      it "should parse the response using the YamlParser if the format is set to yaml" do
        RDefensio::API.configure {|c| c.format = "xml"}
        parser = mock("Xml Parser", :parse => {})
        RDefensio::XmlParser.should_receive(:new).and_return(parser)
        parser.should_receive(:parse)
        RDefensio::API.post_to_defensio("get-stats", {"owner-url" => RDefensio::API.owner_url})
      end
      
      it "should return an OpenStruct object based on the hash created from the parsed response" do
        o = RDefensio::API.post_to_defensio("get-stats", {"owner-url" => RDefensio::API.owner_url})
        o.should be_is_a(OpenStruct)
      end
      
    end
  
    describe "validate_key" do
      
      it "should call post_to_defensio with the correct arguments" do
        RDefensio::API.should_receive(:post_to_defensio).with("validate-key", 
          {"owner-url" => RDefensio::API.owner_url})
        RDefensio::API.validate_key
      end
      
    end
    
    describe "announce_article" do
      
      def article_hash
        {
          "article-author" => "Matt Payne",
          "article-author-email" => "paynmatt@gmail.com",
          "article-title" => 'title', "article-content" => 'content',
          "permalink" => "permalink"
        }
      end
      
      it "should call post_to_defensio with the correct arguments" do
        RDefensio::API.should_receive(:post_to_defensio).with("announce-article", 
          hash_including(article_hash))
        RDefensio::API.announce_article(article_hash)
      end
      
      it "should raise an exception if the article hash is nil" do
        lambda {
          RDefensio::API.announce_article(nil)
        }.should raise_error
      end
      
      it "should raise an exception if the article hash is empty" do
        lambda {
          RDefensio::API.announce_article({})
        }.should raise_error
      end
      
      it "should cleanup the article hash by delegating to the RDefensio::ParamCleanser class" do
        RDefensio::ParamCleanser.should_receive(:cleanup!).with(hash_including(article_hash), 
          RDefensio::Constants::REQUIRED_ARTICLE_PARAMS).
          and_return(article_hash)
        RDefensio::API.announce_article(article_hash)
      end
      
      it "should validate the article hash by delegating to the RDefensio::ParamValidator class" do
        RDefensio::ParamValidator.should_receive(:required_params_present?).with(hash_including(article_hash), 
          RDefensio::Constants::REQUIRED_ARTICLE_PARAMS)
        RDefensio::API.announce_article(article_hash)
      end
      
      it "should add the owner_url parameter" do
        hash = article_hash
        new_hash = hash.merge("owner-url" => RDefensio::API.owner_url)
        hash.should_receive(:merge).with("owner-url" => RDefensio::API.owner_url).and_return(new_hash)
        RDefensio::API.announce_article(hash)
      end
      
    end
    
    describe "audit-comment" do
      
      def comment_hash(other={})
        {
          "user-ip" => "192.168.0.1", "article-date" => DateTime.now, 
          "comment-author" => "Matt Payne", "comment-type" => "comment",
          "comment-content" => "Content", "comment-author-email" => "paynmatt@gmail.com",
          "permalink" => "#{RDefensio::API.owner_url}/post/a-slug", "referrer" => "referrer",
          "user-logged-in" => "false", "trusted-user" => "false"
        }.merge(other)
      end
      
      it "should cleanup the comment hash by delegating to the RDefensio::ParamCleanser class" do
        comment_params = (RDefensio::Constants::REQUIRED_COMMENT_PARAMS + 
            RDefensio::Constants::RECOMMENDED_COMMENT_PARAMS).uniq
        hash = comment_hash
        RDefensio::ParamCleanser.should_receive(:cleanup!).
          with(hash_including(hash), comment_params).and_return(comment_hash)
        RDefensio::API.audit_comment(hash)
      end
      
      it "should raise an exception if the comment hash is nil" do
        RDefensio::ParamCleanser.stub!(:cleanup!).and_return(nil)
        lambda {
          RDefensio::API.audit_comment(comment_hash)
        }.should raise_error
      end
      
      it "should raise an exception if the comment hash is empty" do
        RDefensio::ParamCleanser.stub!(:cleanup!).and_return({})
        lambda {
          RDefensio::API.audit_comment(comment_hash)
        }.should raise_error
      end
      
      it "should raise an exception if the comment type is invalid" do
        lambda {
          RDefensio::API.audit_comment(comment_hash("comment-type" => "blah"))
        }.should raise_error
      end
      
      it "should merge the owner_url and the prepared date into the comment hash" do
        hash = comment_hash
        new_hash = hash.merge("owner-url" => RDefensio::API.owner_url, 
          "article-date" => RDefensio::API.send(:prepare_date, hash["article-date"]))
        hash.should_receive(:merge).with("owner-url" => RDefensio::API.owner_url, "article-date" =>
            RDefensio::API.send(:prepare_date, hash["article-date"])).and_return(new_hash)
        RDefensio::API.audit_comment(hash)
      end
      
      it "should validate the comment hash by delegating to the RDefensio::ParamValidator class" do
        hash = comment_hash("article-date" => RDefensio::API.send(:prepare_date, comment_hash["article-date"]))
        RDefensio::ParamValidator.should_receive(:required_params_present?).with(hash_including(hash), 
          RDefensio::Constants::REQUIRED_COMMENT_PARAMS)
        RDefensio::API.audit_comment(hash)
      end
      
      it "should call post_to_defensio with the proper arguments" do
        hash = comment_hash("article-date" => RDefensio::API.send(:prepare_date, comment_hash["article-date"]))
        RDefensio::API.should_receive(:post_to_defensio).with("audit-comment", hash_including(hash))
        RDefensio::API.audit_comment(hash)
      end
      
      it "should prepare the article date do that it is in the proper format" do
        hash = comment_hash
        date = hash["article-date"]
        RDefensio::API.should_receive(:prepare_date).with(date).and_return("2008/10/21")
        RDefensio::API.audit_comment(hash)
      end
      
    end
    
    describe "report_false_negatives" do
      
      it "should call post_to_rdefensio with the proper arguments with a single signature" do
        hash = {"owner-url" => RDefensio::API.owner_url, "signatures" => "abcdef"}
        RDefensio::API.should_receive(:post_to_defensio).with("report-false-negatives", hash_including(hash))
        RDefensio::API.report_false_negatives("abcdef")
      end
      
      it "should call post_to_rdefensio with the proper arguments with a multiple signatures" do
        hash = {"owner-url" => RDefensio::API.owner_url, "signatures" => "abcdef,ghijklm"}
        RDefensio::API.should_receive(:post_to_defensio).with("report-false-negatives", hash_including(hash))
        RDefensio::API.report_false_negatives("abcdef", "ghijklm")
      end
      
      it "should raise an exception if signatures are nil" do
        lambda {
          RDefensio::API.report_false_negatives
        }.should raise_error
      end
      
    end
    
    describe "report_false_positives" do
      
      it "should call post_to_rdefensio with the proper arguments with a single signature" do
        hash = {"owner-url" => RDefensio::API.owner_url, "signatures" => "abcdef"}
        RDefensio::API.should_receive(:post_to_defensio).with("report-false-positives", hash_including(hash))
        RDefensio::API.report_false_positives("abcdef")
      end
      
      it "should call post_to_rdefensio with the proper arguments with a multiple signatures" do
        hash = {"owner-url" => RDefensio::API.owner_url, "signatures" => "abcdef,ghijklm"}
        RDefensio::API.should_receive(:post_to_defensio).with("report-false-positives", hash_including(hash))
        RDefensio::API.report_false_positives("abcdef", "ghijklm")
      end
      
      it "should raise an exception if signatures are nil" do
        lambda {
          RDefensio::API.report_false_positives
        }.should raise_error
      end
      
    end
    
    describe "get_stats" do
      
      it "should call post_to_defensio with the correct arguments" do
        RDefensio::API.should_receive(:post_to_defensio).with("get-stats", 
          {"owner-url" => RDefensio::API.owner_url})
        RDefensio::API.get_stats
      end
      
    end
  
  end
  
end