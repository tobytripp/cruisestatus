require "open-uri"
begin
  require "json"
rescue LoadError
  require "rubygems"
  require "json"
end
require "cruisestatus/feed_parser"

class CruiseStatus
  class RunCodeRunParser < FeedParser
    attr_accessor :url
    
    def check
      response_json = @feed.read
      response = JSON.parse( response_json )
      @failures = response["user"]["projects"].select { |proj|
        proj["status"] != "success"
      }.map { |proj| proj["name"] }
    rescue Exception => e
      @failures = [e.message]
    end
    
    def failures
      @failures
    end
  end
end