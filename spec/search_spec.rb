require File.dirname(__FILE__) + '/spec_helper.rb'

attrs = {:valid_query => 'google'}

describe Tweetable::Search, 'when performing CRUD' do 
  before do 
    RedisSpecHelper.reset
  end  

  it "should have validations errors with invald data" do
    item = Tweetable::Search.create(:created_at => DateTime.now)
    item.errors.should == [[:query, :not_present]]
  end    
end

describe Tweetable::Search, 'when searching' do 
  before do 
    RedisSpecHelper.reset
    @search = Tweetable::Search.create(:query => attrs[:valid_query], :created_at => DateTime.now)
  end  

  it "should find messages for valid search" do
    @search.update_messages(1)
    @search.messages.first.should be_instance_of Tweetable::Message
  end    
  
  it "should store messages after search" do
    @search.update_messages(1)
    search = Tweetable::Search.find(:query, 'google').first
    search.messages.first.should be_instance_of Tweetable::Message
  end  

  it "should create users associated with messages" do
    @search.update_messages(1)
    search = Tweetable::Search.find(:query, 'google').first
    search.messages.first.from_user.should be_instance_of Tweetable::User
  end  
  
  it "should get multiple pages" do
    @search.update_messages(3)
    search = Tweetable::Search.find(:query, 'google').first
    search.messages.size.should > 200
  end  
  
end