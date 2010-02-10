require "cruisestatus/feed_parser"

# Checks the status of one or more project builds on a cruisecontrol.rb
# server.
# 
# == Example:
# 
#     if CruiseStatus.new( 'http://my.cruise.com/projects.rss' ).pass?
#       puts "Build passed!"
#     else
#       puts "Build failed…Boo!"
#     end
#
class CruiseStatus
  attr_reader :feed_url
  
  # feed_url::
  #   URL pointing to a cruise.rb RSS feed.
  #   Example: "http://my.cruise.com/projects.rss"
  #   or: "http://my.cruise.com/projects/myproject.rss""
  # 
  def initialize( feed_url )
    self.feed_url = feed_url
    check
  end
  
  # Check the given cruise feed and return true if all builds have passed.
  # Returns false otherwise.
  def self.check( feed_url )
    new( feed_url ).pass?
  end
  
  # Update build status
  #
  def check
    @feed_parser.check
  end
 
  # True if all builds described by the feed are passing.
  # 
  def pass?
    @feed_parser.failures.empty?
  end
  
  # A list of failing builds.  Empty if all builds passed.
  # 
  def failures
    @feed_parser.failures
  end
  
  def failure_message
    self.failures.join ", "
  end
  
  def feed_url=( url )
    @feed_parser = FeedParser.for( url )
  end
end