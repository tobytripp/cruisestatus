require "spec_helper"

describe CruiseStatus::FeedParser do
  it "returns an instance of CruiseRbParser" do
    CruiseStatus::CruiseRbParser.should_receive( :new )
    CruiseStatus::FeedParser.for "foo"
  end
  
  it "returns an instance of RunCodeRunParser for runcoderun.com domain" do
    CruiseStatus::RunCodeRunParser.should_receive( :new )
    CruiseStatus::FeedParser.for "http://runcoderun.com/api/v1/json/tobytripp"
  end
end
