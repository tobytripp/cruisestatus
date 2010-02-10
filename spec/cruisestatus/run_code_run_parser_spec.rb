require "spec_helper"
require "cruisestatus/run_code_run_parser"

describe CruiseStatus::RunCodeRunParser do
  describe "on passing builds" do
    before :each do
      @parser =
        CruiseStatus::RunCodeRunParser.new StringIO.new( RCR_PASS_RESPONSE )
      @parser.check
    end

    it "returns an empty failures list" do
      @parser.failures.should == []
    end
  end
  
  describe "on failing builds" do
    before :each do
      @parser =
        CruiseStatus::RunCodeRunParser.new StringIO.new( RCR_FAIL_RESPONSE )
      @parser.check
    end
    
    it "reports failing builds in the response" do
      @parser.failures.should == ["cruisestatus"]
    end
    
    it "fails deliberately" do
      fail "FAIL FAIL FAIL"
    end
    
  end
end

RCR_PASS_RESPONSE = <<-EOS
{"user":{"email":"toby.tripp+runcoderun.com@testmail.com","username":"tobytripp","projects":[{"ended_at":"2010-01-28T12:33:16-06:00","git_url":"http:\/\/github.com\/tobytripp\/cruisestatus","author_name":"Toby","url":"http:\/\/runcoderun.com\/tobytripp\/cruisestatus","branch":"refs\/heads\/master","commit":"7ced1af9afecbb6396b78f86341b4121f026248c","name":"cruisestatus","status":"success","description":"Check the status of your cruise.rb build from your Ruby scripts.","build_url":"http:\/\/runcoderun.com\/tobytripp\/cruisestatus\/builds\/7ced1af9afecbb6396b78f86341b4121f026248c","commit_message":"Regenerated gemspec for version 1.2.1"}]}}
EOS

RCR_FAIL_RESPONSE = <<-EOS
{"user":{"email":"toby.tripp+runcoderun.com@testmail.com","username":"tobytripp","projects":[{"ended_at":"2010-02-10T11:13:16-06:00","git_url":"http:\/\/github.com\/tobytripp\/cruisestatus","author_name":"Toby","url":"http:\/\/runcoderun.com\/tobytripp\/cruisestatus","branch":"refs\/heads\/master","commit":"9a951f0fdbefcd9a019f799049ce4658e6e3686f","name":"cruisestatus","status":"failure","description":"Check the status of your cruise.rb build from your Ruby scripts.","build_url":"http:\/\/runcoderun.com\/tobytripp\/cruisestatus\/builds\/9a951f0fdbefcd9a019f799049ce4658e6e3686f","commit_message":"Fix constant-collision"}]}}
EOS