module Tweetable
  class Authorization < Persistable
    attribute :oauth_access_token
    attribute :oauth_access_secret
    
    index :oauth_access_token
    
    def user_id
      return if self.oauth_access_token.nil?
      self.oauth_access_token.split('-')[0] # tokens start with ID as in: 13705052-bz9IrOTwWbLgWHQDKkGnVd815ybTujc0QeXMlh7ZJ
    end
    
    protected
    
    def validate
      assert_present :oauth_access_token
      assert_present :oauth_access_secret
      assert_unique :oauth_access_token
    end
  end
end