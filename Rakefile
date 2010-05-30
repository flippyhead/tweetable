require 'rubygems'
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
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

# require 'rubygems'
# gem 'hoe', '>= 2.1.0'
# require 'hoe'
# require 'fileutils'
# require './lib/tweetable'
# 
# Hoe.plugin :newgem
# # Hoe.plugin :website
# # Hoe.plugin :cucumberfeatures
# 
# # Generate all the Rake tasks
# # Run 'rake -T' to see list of generated tasks (from gem root directory)
# $hoe = Hoe.spec 'tweetable' do
#   self.developer 'Peter T. Brown', 'peter@flippyhead.com'
#   self.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
#   self.rubyforge_name       = self.name # TODO this is default value
#   # self.extra_deps         = [['activesupport','>= 2.0.2']]
# 
# end
# 
# require 'newgem/tasks'
# Dir['tasks/**/*.rake'].each { |t| load t }
# 
# # TODO - want other tests/tasks run by default? Add them to the list
# # remove_task :default
# # task :default => [:spec, :features]
