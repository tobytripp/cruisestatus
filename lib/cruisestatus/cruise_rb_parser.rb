require 'rexml/document'
require "open-uri"

class CruiseStatus
  class CruiseRbParser
    attr_accessor :url
    
    def initialize( url )
      self.url = url
    end
    
    def check
      project_feed = Kernel.open( url ).read
      @doc = REXML::Document.new project_feed
    rescue Exception => e
      @failures = [e.message]
      @doc = REXML::Document.new ""
    end
    
    def failures
      @failures ||= REXML::XPath.match( @doc, "//item/title" ).select { |element|
        element.text =~ /failed$/
      }.map do |element|
        element.text.gsub( /(.*) build (.+) failed$/, '\1' )
      end
    end
    
    def url=( feed_url )
      @url = feed_url
      @url += '/projects.rss' unless feed_url =~ /\.rss$/
    end
  end
end