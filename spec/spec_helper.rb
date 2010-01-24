$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'cruisestatus'
require 'cruisestatus/command'

require "rubygems"
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  def capture_stdout(&block)
    old_stdout, $stdout = $stdout, StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end
