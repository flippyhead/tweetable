require 'ohm'

module Tweetable
  class Persistable < Ohm::Model
    UPDATE_DELAY = 60*10 # 10 minutes
    
    attribute :created_at
    attribute :updated_at

    def self.find_or_create(attrs, value)      
      model = self.find(attrs, value).first
      model = self.create({attrs => value, :created_at => Time.now.to_s}) if model.nil?
      model
    end
    
    def needs_update?(force = false)
      force or self.updated_at.blank? or (Time.parse(self.updated_at) + UPDATE_DELAY) < Time.now
    end  

    def client
      Tweetable.client
    end    
    
    protected
    
    def validate
      
    end        
  end
end