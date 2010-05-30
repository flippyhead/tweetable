require File.dirname(__FILE__) + '/spec_helper.rb'

attrs = {:valid_query => 'google'}

describe Tweetable::Search, 'when searching' do 
  before do 
    RedisSpecHelper.reset
    @search = Tweetable::Search.create(:query => attrs[:valid_query], :created_at => DateTime.now)
  end  
  
  context 'when searching' do
    before do
      14.times do |page|
        stub_get("http://search.twitter.com/search.json?rpp=100&page=#{page}&since_id=0&q=google", 'search.json')
      end
    end
    
    it "should find messages for valid search" do
      @search.update_messages(1)
      @search.messages.first.should be_instance_of Tweetable::Message
    end    
  
    it "should store messages after search" do
      @search.update_messages(1)
      search = Tweetable::Search.find(:query => 'google').first
      search.messages.first.should be_instance_of Tweetable::Message
    end  

    it "should create users associated with messages" do
      @search.update_messages(1)
      search = Tweetable::Search.find(:query => 'google').first
      search.messages.first.from_user.should be_instance_of Tweetable::User
    end  

    it "should update existing messages but not duplicate in messages list" do
      stub_get("http://search.twitter.com/search.json?q=google&rpp=100&since_id=11674745688&page=1", 'search.json') # since_id is last id in search.json
      
      @search.update_messages(1)
      search = Tweetable::Search.find(:query => 'google').first
      search.messages.size.should == 100
      
      @search.update_messages(1) 
      search.messages.size.should == 100 # not adding duplicates to messages list
    end  
  
    it "should get multiple pages" do
      array = Array.new
      array.stub!(:size => 100)      
      @search.should_receive(:search).exactly(3).times.and_return(mock('search', :results => array))
      @search.update_messages(3)
    end  
  end
  
  context 'when doing CRUD' do
    it "should have validations errors with invald data" do
      item = Tweetable::Search.create(:created_at => DateTime.now)
      item.errors.should == [[:query, :not_present]]
    end        
  end
end