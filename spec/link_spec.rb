require File.dirname(__FILE__) + '/spec_helper.rb'

attrs = {:url => 'http://someurl.com', :created_at => Time.now.to_s, :screen_name => 'somename'}

describe Tweetable::Link, 'when doing CRUD' do 
  before do 
    RedisSpecHelper.reset
    @link = Tweetable::Link.create(:url => attrs[:url], :created_at => attrs[:created_at])    
  end
  
  it "should find link by URL" do
    link = Tweetable::Link.find(:url, attrs[:url]).first
    link.url.should == attrs[:url]
  end
end

describe Tweetable::Link, 'when counting' do 
  before do 
    RedisSpecHelper.reset
    @link = Tweetable::Link.create(:url => attrs[:url], :created_at => attrs[:created_at])
    @user = Tweetable::User.create(:screen_name => attrs[:screen_name])
    @link.users.add(@user)
  end
  
  it "should not increment count for users already in set" do
    @link.should_not_receive(:incr).with(:count)
    @link.increment_usage_count(@user)
  end
  
  it "should increment count for users already in set" do
    user = Tweetable::User.create(:screen_name => attrs[:screen_name] + '_other')
    @link.should_receive(:incr).with(:count)
    @link.increment_usage_count(user)
  end  
end