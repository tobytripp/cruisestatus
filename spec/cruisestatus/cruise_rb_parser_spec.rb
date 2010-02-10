require "spec_helper"
require "cruisestatus/cruise_rb_parser"

describe CruiseStatus::CruiseRbParser do
  describe "on failed build" do
    before :each do
      @parser = CruiseStatus::CruiseRbParser.new StringIO.new( FAIL_RESPONSE )
      @parser.check
    end
    
    it "parses the response correctly" do
      @parser.failures.should == %w[failed]
    end
  end
  
  describe "on passing build" do
    before :each do
      @parser = CruiseStatus::CruiseRbParser.new StringIO.new( PASS_RESPONSE )
      @parser.check
    end
    
    it "parses the response correctly" do
      @parser.failures.should == []
    end
  end
  
  describe "on failed point build" do
    before :each do
      @parser = CruiseStatus::CruiseRbParser.
        new StringIO.new( FAIL_RESPONSE_ON_POINT_REVISION )
      @parser.check
    end
    
    it "parses the response correctly" do
      @parser.failures.should == ["my_project"]
    end
  end
  
  describe "on failed connection" do
    before :each do
      io = StringIO.new("")
      io.stub!(:read).and_raise( Exception )
      
      @parser = CruiseStatus.new io
      @parser.check
    end
    
    it "#failures is not empty" do
      @parser.failures.should_not be_empty
    end
  end
end


FAIL_RESPONSE = <<-EOS
<rss version="2.0">
  <channel>
    <title>CruiseControl RSS feed</title>
    <link>http://localhost:3333/</link>
    <description>CruiseControl projects and their build statuses</description>
    <language>en-us</language>
    <ttl>10</ttl>
    <item>
      <title>failed build 1126 failed</title>
      <description>stuff</description>
      <pubDate>Tue, 17 Jun 2008 22:12:46 Z</pubDate>
      <guid>http://localhost:3333/builds/failed/1126</guid>
      <link>http://localhost:3333/builds/failed/1126</link>
    </item>
    <item>
      <title>passed build 1126 success</title>
      <description>stuff</description>
      <pubDate>Tue, 17 Jun 2008 22:12:46 Z</pubDate>
      <guid>http://localhost:3333/builds/passed/1126</guid>
      <link>http://localhost:3333/builds/passed/1126</link>
    </item>
  </channel>
</rss>
EOS

FAIL_RESPONSE_ON_POINT_REVISION = <<-EOS
<rss version="2.0">
  <channel>
    <title>CruiseControl RSS feed</title>
    <link>http://localhost:3333/</link>
    <description>CruiseControl projects and their build statuses</description>
    <language>en-us</language>
    <ttl>10</ttl>
    <item>
      <title>my_project build 1126.1 failed</title>
      <description>stuff</description>
      <pubDate>Tue, 17 Jun 2008 22:12:46 Z</pubDate>
      <guid>http://localhost:3333/builds/failed/1126</guid>
      <link>http://localhost:3333/builds/failed/1126</link>
    </item>
  </channel>
</rss>
EOS

PASS_RESPONSE = <<-EOS
<rss version="2.0">
  <channel>
    <title>CruiseControl RSS feed</title>
    <link>http://localhost:3333/</link>
    <description>CruiseControl projects and their build statuses</description>
    <language>en-us</language>
    <ttl>10</ttl>
    <item>
      <title>passed build 1127 success</title>
      <description>stuff</description>
      <pubDate>Tue, 17 Jun 2008 22:12:46 Z</pubDate>
      <guid>http://localhost:3333/builds/passed/1127</guid>
      <link>http://localhost:3333/builds/passed/1127</link>
    </item>
    <item>
      <title>passed build 1126 success</title>
      <description>stuff</description>
      <pubDate>Tue, 17 Jun 2008 22:12:46 Z</pubDate>
      <guid>http://localhost:3333/builds/passed/1126</guid>
      <link>http://localhost:3333/builds/passed/1126</link>
    </item>
  </channel>
</rss>
EOS

