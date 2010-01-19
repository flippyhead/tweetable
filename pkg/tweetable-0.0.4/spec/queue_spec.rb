# require File.dirname(__FILE__) + '/spec_helper.rb'
# 
# search_attrs ={:name => 'test-search_queue', :queries => ['google','pathable']}
# 
# describe Tweetable::Queue, 'when adding to search queue' do 
#   before do 
#     RedisSpecHelper.reset
#   end
# 
#   it "should create search queue" do
#     Tweetable::Queue.add_to_search_queue(search_attrs[:name], search_attrs[:queries])
#     queue = Tweetable::SearchCollection.find(:name, search_attrs[:name]).first
#     queue.should_not be_nil
#   end
#   
#   it "should add queries to queue collection" do
#     Tweetable::Queue.add_to_search_queue(search_attrs[:name], search_attrs[:queries])
#     queue = Tweetable::SearchCollection.find(:name, search_attrs[:name]).first
#     queue.searches.size.should == 2    
#   end
#   
#   it "should process things passed to block" do
#     Tweetable::Queue.add_to_search_queue(search_attrs[:name], search_attrs[:queries]) do |search|
#       search.update(:query => 'xxx')
#     end    
#     queue = Tweetable::SearchCollection.find(:name, search_attrs[:name]).first
#     queue.searches.collect{|s| s.query}.should include('xxx')
#   end
# end