module Tweetable
  class User < Persistable
    attribute :created_at
    attribute :updated_at    
    attribute :screen_name
    attribute :profile_image_url
    attribute :user_id
    attribute :friends_count
    attribute :followers_count
    
    index :screen_name
    index :user_id
  
    list :messages, Message
    list :friend_messages, Message
    
    set :friend_ids
    set :follower_ids
    set :tags
    
    def self.create_from_timeline(user)
      u = User.find_or_create(:screen_name, user.screen_name.downcase)
      u.update(
        :user_id => user[:id],
        :profile_image_url => user.profile_image_url,
        :followers_count => user.followers_count, 
        :friends_count => user.friends_count)
      u
    end
    
    def update_all(force = false)
      return unless needs_update?(force)
      
      update_info if self.config[:include_on_update].include?(:info)      
      update_friend_ids if self.config[:include_on_update].include?(:friend_ids)
      update_follower_ids if self.config[:include_on_update].include?(:follower_ids)
      update_friend_messages if self.config[:include_on_update].include?(:friend_messages)
      
      self.update(:updated_at => Time.now.utc.to_s)            
      
      self.config[:include_on_update].include?(:messages) ? update_messages : []  # return newly found messages
    end
  
    def update_info
      uid  = self.screen_name # self.user_id.blank? ? self.screen_name : self.user_id
      info = self.client.user(uid)

      self.user_id = info[:id]
      self.screen_name = info[:screen_name].downcase
      self.profile_image_url = info[:profile_image_url]
      self.friends_count = info[:friends_count]
      self.followers_count = info[:followers_count]      
      self.save
    end
    
    def update_friend_ids    
      fids = self.client.friend_ids(:screen_name => self.screen_name, :page => 1) # limit to 5000 friend ids      
      fids.each{|fid| self.friend_ids << fid}
    end
  
    def update_follower_ids
      fids = self.client.follower_ids(:screen_name => self.screen_name, :page => 1) # limit to 5000 friend ids
      fids.each{|fid| self.follower_ids << fid}
    end
            
    def update_messages(options = {})      
      most_recent_message = self.messages.sort(:order => 'DESC', :by => :message_id).first
      options.merge!(:count => self.config[:max_message_count], :screen_name => self.screen_name)
      options[:since_id] = most_recent_message.message_id if most_recent_message

      timeline = self.client.user_timeline(options)
      build_messages(timeline, self.messages)
    end
    
    def update_friend_messages(options = {})
      most_recent_message = self.friend_messages.sort(:order => 'DESC', :by => :message_id).first
      options.merge!(:count => self.config[:max_message_count], :screen_name => self.screen_name)
      options[:since_id] = most_recent_message.message_id if most_recent_message

      timeline = self.client.friends_timeline(options)      
      build_messages(timeline, self.friend_messages, :create_user => true)
    end
    
    def twitter_link
      "http://twitter.com/#{screen_name}"
    end    

    private 
    def build_messages(timeline, collection, options = {})
      new_messages = []
      
      timeline.each do |message|
        m = Message.create_from_timeline(message, options[:create_user])
        next if !m.valid?
        collection << m
        new_messages << m      
      end
      
      new_messages # return just the newly created messages
    end
    
    def validate
      super      
      assert_unique :screen_name
    end
  end
end