require File.dirname(__FILE__) + '/spec_helper.rb'

describe Tweetable::TwitterStreamingClient, 'when streaming' do 
  before do 
    RedisSpecHelper.reset
    @twitter = Tweetable::TwitterStreamingClient.new
    @twitter.login('flippyhead', 'apple2406')
  end
  
  it "should stream sample" do    
    message = nil
    @twitter.sample do |m|
      message = m
      break
    end
    
    message.should include(:text)
  end
  
  it "should stream track" do
    Tweetable::Message.should_receive(:create_from_timeline).and_raise(Exception)
    lambda{@twitter.run(:track => 'google')}.should raise_error(Exception)
  end
end