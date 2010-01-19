begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rubygems'
require 'ohm'
require 'redis'
require 'tweetable'
# require 'tweetable/persistable' # why does this have to come first?
# require 'tweetable/twitter_client'
# require 'tweetable/link'
# require 'tweetable/photo'
# require 'tweetable/message'
# require 'tweetable/search'
# require 'tweetable/user'
# require 'tweetable/collection'

class RedisSpecHelper
  TEST_OPTIONS = {:db => 15}
  
  def self.reset   
    Tweetable.login('flippyhead', 'apple2406')
    Ohm.connect(TEST_OPTIONS)
    Ohm.flush
  end
end

