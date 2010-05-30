$:.unshift(File.dirname(__FILE__)) unless 
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'logging'
require 'twitter'

module Tweetable
  VERSION = '0.1.7'

  # Generic exception class.
  class TweetableError < StandardError
  end

  class TweetableAuthError < StandardError
  end

  # Raised when there is a temporary problem like Twitter::Unavailable
  class TemporaryPullFromQueueError < TweetableError
  end

  # Raised when there is a problem pulling from the queue
  class PullFromQueueError < TweetableError
  end

  autoload :Persistable, File.join(File.dirname(__FILE__), *%w[tweetable persistable.rb])
  autoload :TwitterClient, File.join(File.dirname(__FILE__), *%w[tweetable twitter_client.rb])
  autoload :TwitterStreamingClient, File.join(File.dirname(__FILE__), *%w[tweetable twitter_streaming_client.rb])
  autoload :Link, File.join(File.dirname(__FILE__), *%w[tweetable link.rb])
  autoload :Photo, File.join(File.dirname(__FILE__), *%w[tweetable photo.rb])
  autoload :Message, File.join(File.dirname(__FILE__), *%w[tweetable message.rb])
  autoload :Search, File.join(File.dirname(__FILE__), *%w[tweetable search.rb])
  autoload :User, File.join(File.dirname(__FILE__), *%w[tweetable user.rb])
  autoload :Collection, File.join(File.dirname(__FILE__), *%w[tweetable collection.rb])
  autoload :UserCollection, File.join(File.dirname(__FILE__), *%w[tweetable collection.rb])
  autoload :MessageCollection, File.join(File.dirname(__FILE__), *%w[tweetable collection.rb])
  autoload :SearchCollection, File.join(File.dirname(__FILE__), *%w[tweetable collection.rb])
  autoload :LinkCollection, File.join(File.dirname(__FILE__), *%w[tweetable collection.rb])
  autoload :Authorization, File.join(File.dirname(__FILE__), *%w[tweetable authorization.rb])
  autoload :URL, File.join(File.dirname(__FILE__), *%w[tweetable url.rb])

  def client
    Thread.current[:twitter_client] ||= options.nil? ? TwitterClient.new.login(*credentials) : TwitterClient.new.authorize(*options)
  end

  def streaming_client
    Thread.current[:twitter_streaming_client] ||= TwitterStreamingClient.new.authorize(*options)
  end

  def login(*credentials)
    @credentials = credentials
  end

  def authorize(*options)
    @options = options
  end

  def options
    @options
  end

  def credentials
    @credentials
  end
  
  def log
    @log = Logging.logger(STDOUT)
    @log.level = :debug
    @log
  end

  module_function :client, :options, :authorize, :login, :credentials, :log
end