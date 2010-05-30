require File.dirname(__FILE__) + '/spec_helper.rb'

describe Tweetable::Collection, 'when building lists' do 
  before do 
    RedisSpecHelper.reset
  end

  it "should dissallow collections without a name" do
    Tweetable::Collection.create.should_not be_valid
  end
  
  it "should build new MessageCollection" do
    Tweetable::MessageCollection.new.should_not be_nil
  end
  
  it "should build new UserCollection" do
    Tweetable::UserCollection.new.should_not be_nil
  end
  
  it "should build new SearchCollection" do
    Tweetable::SearchCollection.new.should_not be_nil
  end

  it "should find or create a new SearchCollection" do
    Tweetable::SearchCollection.find_or_create(:name, 'some-name').should be_instance_of Tweetable::SearchCollection
  end

  it "should find an existing collection" do
    Tweetable::SearchCollection.create(:name => 'some-name')
    Tweetable::SearchCollection.find(:name => 'some-name').first.should be_instance_of Tweetable::SearchCollection
  end  
end

describe Tweetable::Collection, 'when building sets' do 
  before do 
    RedisSpecHelper.reset
  end

  it "should add user to user set" do
    collection = Tweetable::UserCollection.find_or_create(:name, 'some-name')
    collection.user_set.add(Tweetable::User.create(:screen_name => 'this'))
    collection.user_set.size.should == 1
  end

  it "should only add unique users to set" do
    collection = Tweetable::UserCollection.find_or_create(:name, 'some-name')
    user = Tweetable::User.create(:screen_name => 'this', :created_at => Time.now.utc.to_s)
    user2 = Tweetable::User.create(:screen_name => 'this2', :created_at => Time.now.utc.to_s)
    collection.user_set.add(user)
    collection.user_set.add(user2)
    collection.user_set.add(user)
    collection.user_set.size.should == 2
  end
  
end