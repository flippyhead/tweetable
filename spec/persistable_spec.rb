require File.dirname(__FILE__) + '/spec_helper.rb'

attrs = {:now => Time.new.to_s, :then => 'Sat Sep 26 13:32:22 -0700 2009'}

describe Tweetable::Persistable, 'when building' do 
  before do 
    Tweetable.login('l', 'p')
    RedisSpecHelper.reset
  end
  
  it "should have a twitter client" do
    item = Tweetable::Persistable.create(:created_at => attrs[:now], :updated_at => attrs[:now])
    item.send(:client).class.should == Tweetable::TwitterClient
  end
  
  it "should store a persistable item with dates" do
    item = Tweetable::Persistable.create(:created_at => attrs[:now], :updated_at => attrs[:now])
    item.should be_valid
  end
  
  it "should find or create new" do
    item = Tweetable::User.find_or_create(:screen_name, 'Flippyhead')
    item.should be_valid
  end
  
  it "should find or create existing" do
    existing = Tweetable::User.create(:screen_name => 'Flippyhead', :created_at => Time.now.utc.to_s)
    item = Tweetable::User.find_or_create(:screen_name, 'Flippyhead')
    existing.id.to_s.should == item.id.to_s
  end  
end


describe Tweetable::Persistable, 'when needs update' do 
  before do 
    RedisSpecHelper.reset
  end
  
  it "should not need_update when new" do
    item = Tweetable::Persistable.create(:updated_at => attrs[:now])
    item.should_not be_needs_update
  end
  
  it "should need_update when old enough" do
    item = Tweetable::Persistable.create(:updated_at => attrs[:then])
    item.should be_needs_update
  end
  
  it "should need_update when forced" do
    item = Tweetable::Persistable.create(:updated_at => attrs[:now])
    item.should be_needs_update(true)
  end  
end