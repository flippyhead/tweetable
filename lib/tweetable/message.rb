module Tweetable
  class Message < Persistable    
    attr_accessor :owner 
    
    attribute :created_at
    attribute :updated_at    
    attribute :message_id
    attribute :text
    attribute :favorited
    attribute :from_user_id
    attribute :from_screen_name    
    attribute :links_parsed
    attribute :photos_parsed
    attribute :sent_at
    attribute :created_at    
    
    set :links, Link
    set :photos, Photo
    set :tags
    
    index :message_id
    index :links_parsed
    index :photos_parsed
    
    def self.create_from_timeline(message, create_user = false)
      m = Message.find_or_create(:message_id, message[:id])
      
      m.update(
        :favorited => message.favorited, 
        :photos_parsed => '0',
        :links_parsed => '0',
        :created_at => Time.now.utc.to_s, 
        :sent_at => message.created_at,
        :text => message.text, 
        :from_screen_name => message.user.screen_name.downcase, 
        :from_user_id => message.user[:id])
            
      if create_user and m.valid?
        u = User.create_from_timeline(message.user)
        u.messages << m if u.valid?
      end
      m
    end
    
    def self.create_from_status(text, client)
      self.create_from_timeline(client.update(text), true)
    end
    
    def self.purge(&block)
      all.sort.each do |message|
        message.delete if yield(message)
      end
    end
    
    def from_user
      return nil if self.from_screen_name.nil?
      User.find(:screen_name => self.from_screen_name.downcase).first
    end
    
    def parse_links(force = false, longify = true)
      return unless (force or self.links_parsed != '1')

      urls = self.text.scan(Link::URL_PATTERN).flatten
      urls.each do |url|
        link = Link.find(:url => url).first
        
        if !link
          link = Link.create(:url => url, :created_at => Time.new.to_s)
          next if !link.valid?
          
          # link.messages.add(self)
          long_url = URL.lookup_long_url(url)
          link.update(:long_url => long_url) unless (long_url.nil? or long_url == url)
        end

        link.increment_usage_count(from_user)
        
        update(:links_parsed => '1')
        links.add(link)
      end
      
      links
    end
    
    def twitter_link
      "http://twitter.com/#{from_screen_name}/status/#{message_id}"
    end
    
    def validate
      super
      assert_unique :message_id
      assert_present :text
      assert_format :links_parsed, /^[0,1]$/
      assert_format :photos_parsed, /^[0,1]$/
    end
    
    def hash
      self.id.hash
    end

    # Simply delegate to == in this example.
    def eql?(comparee)
      self == comparee
    end

    # Objects are equal if they have the same
    # unique custom identifier.
    def ==(comparee)
      self.id == comparee.id
    end
    
    # It seems that, at least using streaming, message id's are not sequential anymore 
    # So comparisons are done on the official sent_at date/time
    def <=>(o)
      return 1 if o.nil?
      Time.parse(self.sent_at) <=> Time.parse(o.sent_at)
    end
  end
end