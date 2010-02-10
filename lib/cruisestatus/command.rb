require "readline"
require "optparse"
require "cruisestatus/version"

class CruiseStatus::Command
  DEFAULT_PROMPT = "Are you sure you want to check in? (y/n): "
  
  def self.run!( argv )
    @prompt  = nil

    opts = OptionParser.new do |o|
      o.version = CruiseStatus::Version::STRING
      o.release = CruiseStatus::Version::STRING
      o.banner = <<-EOS
  Usage: #{File.basename($0)} [options] BUILD_URL

    Reads the feed at BUILD_URL and reports if the build[s] passed.

  Examples:
    # CruiseControl.rb:
    #{File.basename($0)} http://my.cruiseserver.com
    #{File.basename($0)} http://my.cruiseserver.com/projects.rss
    #{File.basename($0)} http://my.cruiseserver.com/projects/myproject.rss

    # RunCodeRun.com:
    #{File.basename($0)} http://runcoderun.com/api/v1/json/myusername
    
  Options:
      EOS
      
      o.on(
        "-p", "--prompt", "=[PROMPT]",
        "Prompt the user if the build has failed.",
        "#{File.basename($0)} will exit with a non-zero status if the user does not respond 'y' to the prompt."
      ) do |val|
        if val == true
          @prompt = DEFAULT_PROMPT
        else
          @prompt = val
        end
      end
    end
    
    opts.parse! argv
    
    if argv.empty?
      abort opts.to_s
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