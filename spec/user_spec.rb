require File.dirname(__FILE__) + '/spec_helper.rb'

attrs = {:screen_name => 'flippyhead', :user_id => '13705052', :created_at => Time.now.utc.to_s, :updated_at => Time.now.utc.to_s}

describe Tweetable::User do 
  before do 
    RedisSpecHelper.reset  
    @user = Tweetable::User.create(attrs)    
    
    Tweetable.login('l', 'p')
  end
  
  context "when building and saving" do
    it "should store a user item with screen_name, user_id, and created_at attributes" do
      @user.should be_valid
    end
  
    it "should save user info after modification" do 
      @user.user_id = 12345
      @user.save    
      Tweetable::User.find(:screen_name => attrs[:screen_name]).first.user_id.should == '12345'
    end

    it "should set created_at" do 
      Tweetable::User.find(:screen_name => attrs[:screen_name]).first.created_at.should == attrs[:created_at]
    end
  
    it "should not save user info without calling save" do 
      @user.user_id = '12345'
      Tweetable::User.find(:screen_name => attrs[:screen_name]).first.user_id.should == attrs[:user_id]
    end
  
    it "should find stored user by screen_name" do
      Tweetable::User.find(:screen_name => attrs[:screen_name]).first.screen_name.should == attrs[:screen_name]
    end    
  
  end
  
  context "when updating info" do
    before do
      stub_get('/1/users/show/flippyhead.json', 'flippyhead.json', {:login => 'l', :password => 'p'})
      stub_get('/1/users/show/13705052.json', 'flippyhead.json', {:login => 'l', :password => 'p'})
    end
  
    it "should get using just screen_name" do    
      @user.update_info
      @user.user_id.should == 13705052
    end
  
    it "should save after fetching" do
      @user.should_receive(:save)
      @user.update_info
    end  

    it "should get user_id" do
      @user.update_info
      Tweetable::User.find(:screen_name => attrs[:screen_name]).first.user_id.should == attrs[:user_id]
    end  

    it "should get friend count" do
      @user.update_info
      @user.friends_count.should > 0
    end

    it "should get profile image url" do
      @user.update_info
      @user.profile_image_url.should == 'http://a3.twimg.com/profile_images/74792235/screen-capture-2_normal.png'
    end

    it "should get follower counts" do
      @user.update_info
      @user.friends_count.should > 0
    end  
  
    # it "should find stored user by screen_name regardless of case" do
    #   user = Tweetable::User.create(:screen_name => attrs[:screen_name].upcase)
    #   user.update_info
    #   users = Tweetable::User.find(:screen_name => attrs[:screen_name].downcase)
    #   users.first.screen_name.should == attrs[:screen_name]
    # end      
  end
  
  context 'when updating friends and followers' do
    before do 
      stub_get('/1/followers/ids.json?screen_name=flippyhead&page=1', 'follower_ids.json', {:login => 'l', :password => 'p'})
      stub_get('/1/friends/ids.json?screen_name=flippyhead&page=1', 'friend_ids.json', {:login => 'l', :password => 'p'})
    end
    
    it "should update friend_ids" do    
      @user.update_friend_ids
      @user.friend_ids.size.should > 0
    end
  
    it "should update follower_ids" do    
      @user.update_follower_ids
      @user.follower_ids.size.should > 0
    end
  end
  
  context 'when updating messages' do
    before do 
      stub_get('/statuses/friends_timeline.json?screen_name=flippyhead&count=200', 'friends_timeline.json', {:login => 'l', :password => 'p'})
      stub_get('/statuses/user_timeline.json?screen_name=flippyhead&count=200', 'user_timeline.json', {:login => 'l', :password => 'p'})
      stub_get('/statuses/user_timeline.json?screen_name=flippyhead&count=200&since_id=11572672967', 'blank.json', {:login => 'l', :password => 'p'})
    end
    
    it "should return new messages" do    
      @user.update_messages.size.should > 0
    end
      
    it "should store created_at date" do    
      @user.update_messages
      @user.messages.first.created_at.should_not be_nil
    end
    
    it "should build message objects" do    
      @user.update_messages
      @user.messages.first.should be_instance_of Tweetable::Message
      @user.messages.first.text.should_not be_blank
    end
    
    it "should only get created since last message" do 
      @user.update_messages.size.should > 0
      @user.update_messages.size.should == 0    
    end
    
    it "should build friend message objects" do    
      @user.update_friend_messages
      @user.friend_messages.first.should be_instance_of Tweetable::Message
      @user.friend_messages.first.text.should_not be_blank
    end
    
    it "should create associated users for friend messages" do
      @user.update_friend_messages
      @user.friend_messages.first.from_user.should_not be_nil          
    end
  end
end