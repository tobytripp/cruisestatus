require 'rexml/document'
require "open-uri"

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
  # False otherwise.
  def self.check( feed_url )
    new( feed_url ).pass?
  end
  
  # Update build status
  #
  def check
    project_feed = Kernel.open( feed_url ).read
    @doc = REXML::Document.new project_feed
  rescue Exception => e
    @failures = [e.message]
    @doc = REXML::Document.new ""
  end
 
  # True if all builds described by the feed are passing.
  # 
  def pass?
    failures.empty?
  end
  
  # A list of failing builds.  Empty if all builds passed.
  # 
  def failures
    @failures ||= REXML::XPath.match( @doc, "//item/title" ).select { |element|
      element.text =~ /failed$/
    }.map do |element|
      element.text.gsub( /(.*) build (.+) failed$/, '\1' )
    end
  end
  
  def failure_message
    self.failures.join ", "
  end
  
  def feed_url=( url )
    @feed_url = url
    @feed_url += '/projects.rss' unless url =~ /\.rss$/
  end
end