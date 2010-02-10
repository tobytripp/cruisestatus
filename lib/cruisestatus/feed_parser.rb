class CruiseStatus
  class FeedParser
    def self.for( url )
      case url
      when /^http:\/\/runcoderun\.com/
        require "cruisestatus/run_code_run_parser"
        CruiseStatus::RunCodeRunParser.new url
      else
        require "cruisestatus/cruise_rb_parser"
        CruiseStatus::CruiseRbParser.new url
      end
    end
    
    def initialize( url_or_io )
      case url_or_io
      when String
        @feed = Kernel.open( url_or_io )
      when IO, StringIO
        @feed = url_or_io
      else
        raise "Please pass either a URI or an IO object to read."
      end
    end
    
  end
end
