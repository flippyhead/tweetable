require 'rubygems'
require 'tweetstream'
require 'daemons'

module Tweetable
  class TwitterStreamingClient

    def method_missing(sym, *args, &block)
      @client.send sym, *args, &block
    end      

    def initialize(username, password, parser = nil)
      @client = TweetStream::Client.new(username, password, parser)
      setup
      self
    end
    
    def run(query_params)
      query_params = query_params.call if query_params.kind_of?(Proc)
      keywords = query_params[:track]
      keywords = [keywords] unless keywords.kind_of?(Array)
      
      Tweetable.log.debug("Tracking keywords: #{query_params.inspect}")
      
      self.filter(query_params) do |status|
        keywords.each do |keyword|
          store(status, keyword)
        end
      end
    end

    def start(query_params = {}, daemon_options = {}) #:nodoc:
      Daemons.run_proc('tweetable', daemon_options) do
        Tweetable.log.debug("Starting...")
        run(query_params)
      end
    end

    def store(status, keyword)
      if status.text =~ /#{keyword}/i
        message = Message.create_from_timeline(status, true)            
        Tweetable.log.debug("[#{keyword}] #{message.sent_at} #{message.text} (#{message.message_id})")
        
        search = Search.find_or_create(:query, keyword.downcase)
        search.update(:updated_at => Time.now.utc.to_s)
        search.messages << message unless search.messages.include?(message)
      end
      
      message
    end
    
    private 
    def setup
      self.on_delete do |status_id, user_id|
        # do nothing
      end

      self.on_limit do |skip_count|
        raise TweetableError.new("Twitter streaming rate limit reached (#{skip_count})")
      end
      
      self.on_error do |message|
        puts "Error: #{message}"
      end
    end    
  end
end