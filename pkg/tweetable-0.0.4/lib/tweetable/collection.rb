module Tweetable
  class Collection < Persistable    
    attribute :created_at
    attribute :updated_at    
    attribute :name  # super class attributes don't get picked up in subclasses for some reason
    index :name
        
    def validate
      assert_present :name
      assert_unique :name
    end
  end  
  
  class UserCollection < Collection
    attribute :created_at
    attribute :updated_at
    attribute :name  
    index :name
    
    set  :user_set, User
    list :users, User
  end  

  class MessageCollection < Collection    
    attribute :created_at
    attribute :updated_at
    attribute :name  
    index :name
    
    set  :message_set, Message
    list :messages, Message
  end  
  
  class SearchCollection < Collection
    attribute :created_at
    attribute :updated_at
    attribute :name  
    index :name
    
    set  :search_set, Search
    list :searches, Search
  end    
  
  class LinkCollection < Collection
    attribute :created_at
    attribute :updated_at
    attribute :name  
    index :name
    
    set  :link_set, Link
    list :links, Link
  end    
  
end