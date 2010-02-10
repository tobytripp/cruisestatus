require "cruisestatus/cruise_rb_parser"

class CruiseStatus
  module FeedParser
    def self.for( url )
      CruiseStatus::CruiseRbParser.new url
    end
  end
end