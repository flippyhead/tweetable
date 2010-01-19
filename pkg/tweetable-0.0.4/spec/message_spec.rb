require File.dirname(__FILE__) + '/spec_helper.rb'

attrs = {:short_url => 'http://bit.ly/k1n4M', :long_url => 'http://pathable.com', :from_screen_name => 'somename'}

describe Tweetable::Message, 'when doing CRUD' do 
  before do 
    RedisSpecHelper.reset
    
    @user = Tweetable::User.create(:screen_name => attrs[:from_screen_name])
    @message = Tweetable::Message.create(
      :message_id => '1234', 
      :text => "here a link http://www.thisisalink.com/with-a-path/and-so_forth.xml there a link #{attrs[:short_url]}",
      :links_parsed => "0", 
      :photos_parsed => "0",
      :from_screen_name => attrs[:from_screen_name],
      :created_at => Time.now
    )
    @message.parse_links        
  end
  
  it "shuould find from_user" do
    @message.from_user.should == @user
  end
end

describe Tweetable::Message, 'when parsing links' do 
  before do 
    RedisSpecHelper.reset
    
    @user = Tweetable::User.create(:screen_name => attrs[:from_screen_name])
    @message = Tweetable::Message.create(
      :message_id => '1234', 
      :text => "here a link http://www.thisisalink.com/with-a-path/and-so_forth.xml there a link #{attrs[:short_url]}",
      :links_parsed => "0", 
      :photos_parsed => "0",
      :from_screen_name => attrs[:from_screen_name],
      :created_at => Time.now
    )
    @message.parse_links        
  end
  
  it "should should add of Link type" do
    @message.links.first.should be_instance_of Tweetable::Link
  end
  
  it "should add with correct URL" do
    @message.links.first.url.should == 'http://www.thisisalink.com/with-a-path/and-so_forth.xml'
  end
  
  it "should extract multiple" do
    @message.links.size.should == 2
  end
  
  it "should initialize counter at 1" do    
    @message.links.first.count.should == 1
  end
  
  it "should flag message as parsed" do
    @message.links_parsed.should == "1"
  end
  
  it "should not parse already parsed" do
    @message.text.should_not_receive(:scan)
    @message.parse_links
  end
  
  it "should be able to find parsed links" do
    @message.parse_links
    link = Tweetable::Link.find(:url, attrs[:short_url]).first
    link.should_not be_nil
  end
  
  it "should search messages for non parsed links" do
    Tweetable::Message.search(:links_parsed => "0") do |results|
      results.each do |message|
        links = message.parse_links
        links.size.should == 1
      end    
    end
  end
  
  it "should get long url for short urls" do
    @message.links.all[1].long_url.should == attrs[:long_url]
  end
  
  it "should increment links count on other messages with link" do
    Tweetable::User.create(:screen_name => attrs[:from_screen_name] + '_other')
    
    message = Tweetable::Message.create(
      :message_id => '5678', 
      :text => "xxx #{attrs[:short_url]} rrr", 
      :created_at => Time.now.to_s, 
      :from_screen_name => attrs[:from_screen_name] + '_other',
      :links_parsed => "0", 
      :photos_parsed => "0")
      
    message.parse_links
    message.links.first.count.should == 2
  end

  it "should not increment links count on other messages from same user" do    
    message = Tweetable::Message.create(
      :message_id => '5678', 
      :text => "xxx #{attrs[:short_url]} rrr", 
      :links_parsed => "0", 
      :photos_parsed => "0",
      :from_screen_name => attrs[:from_screen_name],
      :created_at => Time.now)
      
    message.parse_links
    message.links.first.count.should == 1
  end
  
  it "should not try to create already existing link" do
    message = Tweetable::Message.create(:message_id => '5678', :text => "xxx #{attrs[:short_url]}", :created_at => Time.now, :links_parsed => "0", :photos_parsed => "0")
    Tweetable::Link.should_not_receive(:create)
    message.parse_links    
  end
end