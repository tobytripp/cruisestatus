require "optparse"

require "highline"
require "highline/import"
require "cruisestatus/version"

class CruiseStatus::Command
  USAGE = <<-EOS
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
  
  DEFAULT_PROMPT = "Are you <%= color 'sure', :underline %> you want to check in? (y/n): "
  
  attr_writer :prompt
  
  def self.run!( argv )
    self.new.run( argv )
  end

  def are_you_sure?( status )
    say "Build <%= color 'FAILURES', :red, :bold %>:"
    say $terminal.color( status.failure_message, :red )
    agree( prompt ) ? 0 : 1
  end
  
  def initialize()
    @prompt = false
  end
  
  def run( argv )
    argv = parse_options( argv )
    
    if argv.empty?
      Kernel.abort @options.to_s
    else
      status = CruiseStatus.new argv.last
      
      if status.pass?
        say "Build <%= color 'PASSED', :green, :bold %>"
        0
      else
        return are_you_sure?( status ) if @prompt
        1
      end
    end
  end
  
  def parse_options( argv )
    @options = OptionParser.new do |option|
      option.version = CruiseStatus::Version::STRING
      option.release = CruiseStatus::Version::RELEASE
      option.banner  = CruiseStatus::Command::USAGE

      option.on(
        "-p", "--prompt", "=[PROMPT]",
        "Prompt the user if the build has failed.",
        "#{File.basename($0)} will exit with a non-zero status if the user " \
          "does not respond 'y' to the prompt."
      ) do |val|
        if val == true
          self.prompt = DEFAULT_PROMPT
        else
          self.prompt = val
        end
      end
    end

    @options.parse! argv
  end
  
  def prompt
    @prompt || DEFAULT_PROMPT
  end
end