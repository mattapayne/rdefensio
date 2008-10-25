require File.join(File.dirname(__FILE__), "dependencies")

module RDefensio
  
  class RDefensioException < RuntimeError
    
    def initialize(msg)
      super(msg)
    end
    
  end
    
  class API
  
    private_class_method(:new)
  
    class << self
  
      DEFAULT_SERVICE_TYPE = "blog".freeze
      DEFAULT_API_VERSION = "1.2".freeze
      DEFAULT_FORMAT = "yaml".freeze
      BASE_URL = "api.defensio.com".freeze
  
      attr_accessor :service_type, :api_version, :api_key, :format, :owner_url, :poster
    
      def configure
        raise RDefensioException.new("Configure requires a block") unless block_given?
        yield(self)
      end
    
      def service_type
        @service_type || DEFAULT_SERVICE_TYPE
      end
    
      def api_version
        @api_version || DEFAULT_API_VERSION
      end
    
      def format
        @format || DEFAULT_FORMAT
      end
    
      def poster
        @poster || Poster.new(BASE_URL)
      end
    
      def valid?
        ParamValidator.valid?(self)
      end
    
      # -------------------- API Methods -----------------------------------------
    
      def validate_key
        return post_to_defensio("validate-key", {"owner-url" => owner_url})
      end
    
      def announce_article(article_hash)
        article_hash = ParamCleanser.cleanup!(article_hash, REQUIRED_ARTICLE_PARAMS)
        raise RDefensioException.new("The article hash cannot be nil or empty.") if (article_hash.nil? || article_hash.empty?)
        ParamValidator.required_params_present?(article_hash, REQUIRED_ARTICLE_PARAMS)
        return post_to_defensio("announce-article", { "owner-url" => owner_url }.merge(article_hash))
      end
    
      def announce_article(article_author, article_author_email, article_title, 
          article_content, permalink)
        return announce_article({"article-author" => article_author,
            "article-author-email" => article_author_email, "artitle-title" => article_title,
            "article-content" => article_content, "permalink" => permalink})
      end
   
      def audit_comment(comment_hash)
        comment_hash = ParamCleanser.cleanup!(comment_hash, 
          (REQUIRED_COMMENT_PARAMS + RECOMMENDED_COMMENT_PARAMS).uniq)
        raise RDefensioException.new("The comment hash cannot be nil or empty.") if (comment_hash.nil? || comment_hash.empty?)
        raise RDefensioException.new("Invalid comment type: #{comment_hash["comment-type"]}.") unless COMMENT_TYPES.include?(comment_hash["comment-type"])
        ParamValidator.required_params_present?(comment_hash, REQUIRED_COMMENT_PARAMS)
        comment_hash["article-date"] = prepare_date(comment_hash["article-date"])
        return post_to_defensio("audit-comment", { "owner-url" => owner_url }.merge(comment_hash))
      end
    
      def audit_comment(user_ip, article_date, comment_author, comment_type, optional_params={})
        return audit_comment({"user-ip" => user_ip, "article-date" => article_date,
            "comment-author" => comment_author, "comment-type" => comment_type}.merge(optional_params))
      end
    
      def report_false_negatives(*signatures)
        return post_to_defensio("report-false-negatives", {"owner-url" => owner_url, 
            "signatures" => signatures.join(",")})
      end
    
      def report_false_positives(*signatures)
        return post_to_defensio("report-false-positives", {"owner-url" => owner_url, 
            "signatures" => signatures.join(",")})
      end
    
      def get_stats
        return post_to_defensio("get-stats", {"owner-url" => owner_url})
      end
    
      # ------------------- End API Methods --------------------------------------
    
      private
    
      def post_to_defensio(action, post_data)
        raise RDefensioException.new("An action must be specified.") if (action.nil? || action.empty?)
        raise RDefensioException.new("Post data is required.") if (post_data.nil? || post_data.empty?)
        raise RDefensioException.new("Invalid action: #{action}.") unless ACTIONS.include?(action)
        #encode the data and post to Defensio
        response = poster.post(create_url(action), create_post_data(post_data))
        parser = get_response_parser(response)
        return OpenStruct.new(parser.parse)
      end
    
      def get_response_parser(response)
        if format == "xml"
          return XmlParser.new(response.body)
        end
        return YamlParser.new(response.body)
      end
    
      def prepare_date(date)
        return if date.nil?
        if date.is_a?(String)
          date = Date.parse(date)
        end
        return date.strftime("%Y/%m/%d")
      end

      def create_url(action)
        raise RDefensioException.new("An action must be specified.") if (action.nil? || action.empty?)
        url = ['', service_type, api_version, action, api_key].join("/")
        return URI.escape("#{url}.#{format}")
      end

      def create_post_data(hash)
        raise RDefensioException.new("Post data must be a hash.") unless hash.is_a?(Hash)
        return hash.inject(String.new) do |str, (key, value)|
          str << "#{CGI.escape(key)}=#{CGI.escape(value)}&"
        end.chomp("&")
      end
    
    end
    
  end
  
end
