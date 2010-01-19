require 'rubygems'
require 'tweetstream'

module Tweetable
  class TwitterStreamingClient

    def method_missing(sym, *args, &block)
      @client.send sym, *args, &block
    end      

    def login(username, password, process_id = nil)
      @client = process_id ? TweetStream::Daemon.new(username, password, process_id) : TweetStream::Client.new(username, password)
      setup
      self
    end

    def run(query_params)
      keyword = query_params[:track]
      
      self.filter(query_params) do |status|
        message = Message.create_from_timeline(status, true)
        if message.text =~ /#{keyword}/
          Tweetable.log.debug("[#{keyword}] Adding message: #{message.text}")
          
          search = Search.find_or_create(:query, keyword)
          search.update(:updated_at => Time.now.to_s)
          search.messages << message.id
        end
      end
    end
    
    private 
    def setup
      self.on_delete do |status_id, user_id|
        # do nothing
      end

      self.on_limit do |skip_count|
        raise TweetableError.new("Twitter streaming rate limit reached (#{skip_count})")
      end      
    end    
  end
end