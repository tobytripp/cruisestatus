require "readline"
require "optparse"

class CruiseStatus::Command
  DEFAULT_PROMPT = "Are you sure you want to check in? (y/n): "
  
  def self.run!( argv )
    @prompt = nil
    
    opts = OptionParser.new do |o|
      o.banner = <<-EOS
      Usage: #{File.basename($0)} [options] CRUISE_RB_RSS_URL

        Reads the feed at CRUISE_RB_RSS_URL and reports if the build[s] passed.

      Examples:
        #{File.basename($0)} http://my.cruiseserver.com
        #{File.basename($0)} http://my.cruiseserver.com/projects.rss
        #{File.basename($0)} http://my.cruiseserver.com/projects/myproject.rss
      
      EOS
      
      o.on( "-p", "--prompt" ) { |val| @prompt = DEFAULT_PROMPT }
    end
    
    opts.parse! argv
    
    if argv.empty?
      abort opts.banner
    else
      status = CruiseStatus.new argv.last
      
      if status.pass?
        puts "Build PASSED"
        0
      else
        return are_you_sure?( status ) if @prompt
        1
      end
    end
  end
  
  def self.are_you_sure?( status )
    puts "\n", "Build FAILURES: #{status.failure_message}"
    input = ""
    while( input && input.strip.empty? )
      input = Readline.readline @prompt
    end
    
    input.strip.downcase[0,1] == "y" ? 0 : 1
  end
end