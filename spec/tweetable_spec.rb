require File.dirname(__FILE__) + '/spec_helper.rb'

describe Tweetable do 
  before do 
    Tweetable.config({:max_message_count=>10})
    RedisSpecHelper.reset
  end
  
  context 'when configuring' do
    it "should use default config values" do 
      Tweetable.config.should == Tweetable::DEFAULT_CONFIG
    end
    
    it "should update the config" do
      Tweetable.config({:max_message_count=>101})
      Tweetable.config[:max_message_count].should == 101
    end
  end  
end  
