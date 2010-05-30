module Tweetable
  class Search < Persistable
    SEARCH_PER_PAGE_LIMIT = 100
    SEARCH_START_PAGE = 1
  
    attribute :created_at
    attribute :updated_at
    attribute :query
    index :query 
    list :messages, Message        
    
    def update_all(force = false)
      return unless needs_update?(force)
      self.updated_at = Time.now.utc.to_s
      self.save
      update_messages
    end
    
    # Perform the search and update messages if any new exist
    # Do up to 15 requests to collect as many historical messages as possible
    # Because search API is different than the resto f the Twitter API this needs to be custom (i.e. cannot use xxx_from_timeline methods)
    def update_messages(pages = 15)
      most_recent_message = self.messages.first(:order => 'DESC', :by => :message_id) 
      since_id = most_recent_message.nil? ? 0 : most_recent_message.message_id

      search_messages = []
      pages.times do |page|
        s = search(self.query, since_id, SEARCH_PER_PAGE_LIMIT, page+1)
        break if s.results.nil?
        search_messages += s.results
        break if s.results.size < 99                      
      end
      
      search_messages.each do |message|        
        m = Message.find_or_create(:message_id, message.id)
        
        m.update(
        :message_id => message.id, 
        :favorited => message.favorited, 
        :photos_parsed => '0',
        :links_parsed => '0',          
        :created_at => Time.now.utc.to_s, 
        :sent_at => message.created_at,
        :text => message.text, 
        :from_screen_name => message.from_user) # we explicitly don't include the user_id provided by search since it's bullshit: http://code.google.com/p/twitter-api/issues/detail?id=214
          
        next if !m.valid?
          
        # create the user for this message
        u = User.find_or_create(:screen_name, message.from_user)
        u.update(
          :user_id => message.from_user_id,
          :profile_image_url => message.profile_image_url)

        self.messages << m unless self.messages.include?(m)
      end
      
      search_messages.flatten
    end
    
    
    private 
    
    def validate
      assert_present :query
      assert_unique :query
    end    
    
    def search(query, since_id, per_page = SEARCH_PER_PAGE_LIMIT, page = SEARCH_START_PAGE)      
      begin
        Twitter::Search.new(query.strip).since(since_id).per_page(per_page).page(page).fetch
      rescue NoMethodError => e
        raise TweetableError.new("Temporary problem searching Twitter: #{e}")
      end
    end    
  end
end