begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'rspec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rubygems'
require 'ohm'
require 'redis'
require 'tweetable'
require 'fakeweb'

FakeWeb.allow_net_connect = false

def twitter_url(path, login=nil, password=nil)
  if path =~ /^http/
    path
  else
    login || pass ? "http://#{login}:#{password}@api.twitter.com#{path}" : path
  end    
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(url, filename, options = {})
  fwoptions = {:body => fixture_file(filename)}
  fwoptions.merge!({:status => options[:status]}) unless options[:status].nil?
  FakeWeb.register_uri(:get, twitter_url(url, options[:login], options[:password]), fwoptions)
end

def stub_post(url, filename)
  FakeWeb.register_uri(:post, twitter_url(url), :body => fixture_file(filename))
end

def stub_put(url, filename)
  FakeWeb.register_uri(:put, twitter_url(url), :body => fixture_file(filename))
end


class RedisSpecHelper
  TEST_OPTIONS = {:db => 11}
  
  def self.reset    
    Ohm.connect(TEST_OPTIONS)
    Ohm.flush
  end
end

