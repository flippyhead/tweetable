module Tweetable
  class Link < Persistable
    URL_PATTERN = /(http:\S+)/ix
    
    attribute :created_at
    attribute :updated_at
    attribute :url
    attribute :long_url  
    
    index :url
    index :long_url
    
    # set :messages, Tweetable::Message
    set :users, Tweetable::User
    counter :count    
    
    def increment_usage_count(user)
      return false if (user.nil? || self.users.include?(user.id))
      users.add(user)
      self.incr(:count)
    end
    
    protected
    
    def validate
      assert_present :url
      assert_unique :url
    end
  end
end