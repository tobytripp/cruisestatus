require 'spec_helper'

describe CruiseStatus do
  describe "on failed build" do
    before :each do
      @parser = mock( "failing feed parser",
        :failures => ["failed build"],
        :check => nil
      )
      CruiseStatus::FeedParser.stub!( :for ).and_return @parser
      
      @status = CruiseStatus.new 'ccrb.rss'
    end
    
    it "delegates #failures to the feed parser" do
      @parser.should_receive( :failures ).and_return :failures
      @status.failures.should == :failures
    end
    
    it "#pass? is false" do
      @status.should_not be_pass
    end
  end
  
  describe "on passing build" do
    before :each do
      @parser = mock( "passing feed parser",
        :failures => [],
        :check => nil
      )
      CruiseStatus::FeedParser.stub!( :for ).and_return @parser
      
      @status = CruiseStatus.new 'ccrb.rss'
    end
    
    it "delegates #failures to the feed parser" do
      @parser.should_receive( :failures ).and_return :failures
      @status.failures.should == :failures
    end
    
    it "#pass? is true" do
      @status.should be_pass
    end
  end
end
