require File.dirname(__FILE__) + '/spec_helper.rb'

describe Tweetable::TwitterStreamingClient, 'when streaming' do 
  before do 
    RedisSpecHelper.reset
    @twitter = Tweetable::TwitterStreamingClient.new('flippyhead', 'apple2406')
  end
  
  # it "should stream sample" do    
  #   message = nil
  #   @twitter.sample do |m|
  #     message = m
  #     break
  #   end
  # 
  #   message.should include(:text)
  # end  
end