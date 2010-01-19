module Tweetable
  class Queue
    def self.clear_search_queue(queue_name)
      collection = Tweetable::SearchCollection.find(:name, queue_name).first
      return true if collection.nil?
      collection.searches.size.times{|i| collection.searches.pop}
      true
    end

    def self.clear_user_queue(queue_name)
      collection = Tweetable::UserCollection.find(:name, queue_name).first
      return true if collection.nil?
      collection.users.size.times{|i| collection.users.pop}
      true
    end
    
    def self.add_to_search_queue(queue_name, queries, &block)
      queue = Tweetable::SearchCollection.find_or_create(:name, queue_name)
      return unless queue.searches.empty?

      queries.each do |query|
        search = Tweetable::Search.find_or_create(:query, query)

        yield search if block_given?

        queue.searches << search.id
      end

      queue
    end

    def self.add_to_user_queue(queue_name, screen_names, &block)
      queue = Tweetable::UserCollection.find_or_create(:name, queue_name)
      return unless queue.users.empty?

      screen_names.each do |screen_name|
        user = Tweetable::User.find_or_create(:screen_name, screen_name)

        yield user if block_given?        

        queue.users << user.id
      end
    end    

    def self.pull_from_search_queue(queue_name)
      queue = Tweetable::SearchCollection.find(:name, queue_name).first
      return 0 if (queue.nil? or queue.searches.empty?)

      count = 0
      while !queue.searches.empty?        
        search = Tweetable::Search[queue.searches.pop] # have to find object by id in List
        process_search(search)
        count += 1
      end     

      return count
    end  
    
    def self.pull_from_user_queue(queue_name)
      queue = Tweetable::UserCollection.find(:name, queue_name).first
      return if (queue.nil? or queue.users.empty?)

      count = 0
      while !queue.users.empty?        
        user = Tweetable::User[queue.users.pop] # have to find object by id in List
        process_user(user)
        count += 1
      end     

      return count
    end
    
    def self.process_search(search)
      pull_from_queue_safely do
        return search.update_all(true)          
      end
    end
    
    def self.process_user(user)
      pull_from_queue_safely do
        messages = user.update_all(true)
        user.tags.each do |tag|
          message_collection = Tweetable::MessageCollection.find_or_create(:name, tag)
          user_collection = Tweetable::UserCollection.find_or_create(:name, tag)                    

          message_collection.update(:updated_at => Time.now.to_s)
          user_collection.update(:updated_at => Time.now.to_s)

          user_collection.user_set.add(user)
          messages.each{|m| message_collection.messages << m.id}
        end
        return messages
      end
    end    
    
    def self.pull_from_queue_safely
      begin
        yield
      rescue Tweetable::TweetableError => e      
        raise TemporaryPullFromQueueError.new("Twitter unavailable error: #{e}")
      rescue Twitter::Unavailable => e      
        raise TemporaryPullFromQueueError.new("Twitter unavailable error: #{e}")      
      rescue URI::InvalidURIError => e      
        raise PullFromQueueError.new("Bad uri error: #{e}")
      rescue ArgumentError => e
        raise PullFromQueueError.new("Argument error: #{e}")
      rescue Crack::ParseError => e
        raise PullFromQueueError.new("Parsing error: #{e}")
      rescue Twitter::NotFound => e
        raise PullFromQueueError.new("Account does not exist: #{e}")
      rescue Twitter::Unauthorized => e
        raise PullFromQueueError.new("Not authorized error: #{e}")
      rescue Errno::ETIMEDOUT => e
        raise PullFromQueueError.new("Connection timed out error: #{e}")
      rescue Exception => e
        HoptoadNotifier.notify(e)          
        raise PullFromQueueError.new("General error: #{e}")
      end
    end
  end  
end