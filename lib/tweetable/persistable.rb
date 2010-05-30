require 'ohm'

module Tweetable
  class Persistable < Ohm::Model
    UPDATE_DELAY = 60*10 # 10 minutes
    
    attribute :created_at
    attribute :updated_at

    def self.find_or_create(key, value)      
      attributes = {key => value} # this persistable uses an old interface
      models = self.find(attributes)
      models.empty? ? self.create(attributes.merge(:created_at => Time.now.utc.to_s)) : models.first
    end
    
    def needs_update?(force = false)
      force or self.updated_at.blank? or (Time.parse(self.updated_at) + UPDATE_DELAY) < Time.now.utc
    end  

    def client
      Tweetable.client
    end    
    
    protected
    
    def validate
      
    end        
  end
end