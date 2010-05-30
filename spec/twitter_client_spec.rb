require File.dirname(__FILE__) + '/spec_helper.rb'

describe Tweetable::TwitterClient do 
  before do 
    RedisSpecHelper.reset
    stub_get('/account/rate_limit_status.json', 'rate_limit_status.json', {:login => 'l', :password => 'p'})
    stub_get('/account/verify_credentials.json', 'verify_credentials.json', {:login => 'l', :password => 'p'})
    
    @twitter = Tweetable::TwitterClient.new
  end

  context 'when not logged in' do
    it "should require login" do
      expect {
        @twitter.verify_credentials
      }.should raise_exception(Tweetable::TweetableAuthError)
    end
  end
  
  context 'when logged in' do
    before do       
      @twitter.login('l', 'p')
    end
  
    it "should verify credentials of valid user" do
      info = @twitter.verify_credentials
      info.name.should == 'Peter T. Brown'
    end
  
    it "should get rate limit status" do
      @twitter.status.should include(:hourly_limit)
    end
  end
end