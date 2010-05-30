# require 'yajl'
require 'crack'
require 'crack/json'
require 'net/http'
require 'cgi'
  
module Tweetable
  class URL  
    LONG_URL_API_URL = 'http://www.longurlplease.com/api/v1.1'  
    LONG_URL_TIMEOUT = 5  
  
    def self.headers  
      { "Content-Type" => 'application/json' }  
    end  
  
    # the api can handle multiple url queries and response, but this does just 1  
    def self.lookup_long_url(search)  
      url = URI.parse(LONG_URL_API_URL)  
      url.query = "q=#{CGI.escape(search)}"  
         
      http = Net::HTTP.new(url.host, url.port)  
      http.read_timeout = LONG_URL_TIMEOUT  
        
      long_url = nil
      begin
        json = http.get(url.to_s, headers).body
        urls =  Crack::JSON.parse(json)
        long_url = urls.values[0]
      rescue Crack::ParseError
        raise TweetableError.new("Error parsing json trying to get long URL: #{json.to_s}")        
      rescue Timeout::Error => e
        raise TweetableError.new("Timeout trying to get long URL: #{e}")
      rescue Exception => e      
        raise TweetableError.new("Error trying to get long URL: #{e}")
      end      
      long_url.nil? ? search : long_url
    end   
  end  
end