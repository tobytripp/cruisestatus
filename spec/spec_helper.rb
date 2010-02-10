$LOAD_PATH.unshift( File.dirname(__FILE__) )
$LOAD_PATH.unshift( File.join(File.dirname(__FILE__), '..', 'lib') )

require "rubygems"
require 'spec'
require 'spec/autorun'

require 'cruisestatus'
require 'cruisestatus/command'


Spec::Runner.configure do |config|
  def capture_stdout(&block)
    old_stdout, $stdout = $stdout, StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end
