require File.dirname(__FILE__) + '/spec_helper.rb'

describe Tweetable::TwitterClient, 'when building' do 
  before do 
    RedisSpecHelper.reset
    @twitter = Tweetable::TwitterClient.new
    @twitter.login('flippyhead', 'apple2406')
  end
  
  it "should verify credentials of valid user" do
    info = @twitter.verify_credentials
    info.name.should == 'Peter T. Brown'
  end
  
  it "should get rate limit status" do
    @twitter.status.should include(:hourly_limit)
  end
end