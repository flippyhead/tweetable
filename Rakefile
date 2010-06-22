require 'rubygems'
require 'bundler'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "tweetable"
    gemspec.summary = "Track twitter messages and users in memory using Redis"
    gemspec.description = "Track twitter messages and users in memory using Redis"
    gemspec.email = "peter@flippyhead.com"
    gemspec.homepage = "http://github.com/flippyhead/tweetable"
    gemspec.authors = ["Peter T. Brown"]
    gemspec.add_bundler_dependencies
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end