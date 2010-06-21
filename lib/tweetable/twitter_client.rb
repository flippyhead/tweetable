module Tweetable
  class TwitterClient
    attr_accessor :consumer_token, :consumer_secret, :authorization #:oauth_access_token, :oauth_access_secret
    
    def method_missing(sym, *args, &block)
      raise TweetableAuthError.new('Not authorized. You must login or authorize the client.') if @client.nil?
      @client.send sym, *args, &block
    end      
    
    def authorize(token, secret, authorization)
      raise TweetableAuthError if authorization.nil?
      
      self.authorization = authorization
      self.consumer_token = token
      self.consumer_secret = secret      
      self.oauth.authorize_from_access(self.authorization.oauth_access_token, self.authorization.oauth_access_secret)
            
      @client = Twitter::Base.new(self.oauth)
      self
    end
    
    def login(username, password)
      @client = Twitter::Base.new(Twitter::HTTPAuth.new(username, password))
      self
    end
    
    def oauth      
      @oauth ||= Twitter::OAuth.new(self.consumer_token, self.consumer_secret)      
    end
    
    def status
      status = self.rate_limit_status
      {:hourly_limit => status[:hourly_limit], :remaining_hits => status[:remaining_hits], :reset_time => status[:reset_time], :reset_time_in_seconds => status[:reset_time_in_seconds]}
    end  
  end
end