module RDefensio
  
  module Constants
  
    SERVICE_TYPES = ["blog", "app"].freeze
    FORMATS = ["xml", "yaml"].freeze
    COMMENT_TYPES = ["comment", "trackback", "pingback", "other"].freeze
    REQUIRED_COMMENT_PARAMS = ["owner-url", "user-ip", "article-date", 
      "comment-author", "comment-type"].freeze
    RECOMMENDED_COMMENT_PARAMS = ["comment-comment", "comment-author-email", 
      "comment-author-url", "permalink", "referrer", "user-logged-in", "trusted-user",
      "openid", "test-force"].freeze
    REQUIRED_ARTICLE_PARAMS = ["owner-url", "article-author", "article-author-email",
      "article-title", "article-content", "permalink"].freeze
    ACTIONS = ["validate-key", "announce-article", "audit-comment", 
      "report-false-negatives", "report-false-positives", "get-stats"].freeze
    URL_REGEX =  /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix.freeze
  
  end
  
end