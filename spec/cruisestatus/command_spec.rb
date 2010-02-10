require "spec_helper"

describe CruiseStatus::Command do
  before :each do
    @status = mock( "cruisestatus" )
    @status.stub!( :pass? ).and_return true
    @status.stub!( :failure_message ).and_return "FAILURES"
    
    CruiseStatus.stub!( :new ).with( "url" ).and_return @status
    
    @old_terminal = $terminal
    $terminal = HighLine.new( StringIO.new, @output = StringIO.new )
  end
  
  after :each do
    $terminal = @old_terminal
  end
  
  it "passes the given url to the cruise status checker" do
    CruiseStatus.should_receive( :new ).with( "url" ).and_return @status
    CruiseStatus::Command.run! ["url"]
  end
  
  it "returns 0 if the builds have passed" do
    @status.should be_pass
    CruiseStatus::Command.run!( ["url"] ).should == 0
  end
  
  it "returns 1 if the builds have failed" do
    @status.should_receive( :pass? ).and_return false
    CruiseStatus::Command.run!( ["url"] ).should == 1
  end
  
  it "aborts if no url is provided" do
    Kernel.should_receive( :abort )
    CruiseStatus::Command.run! []
  end
  
  describe "when given the 'prompt' option" do
    before :each do
      @status.stub!( :pass? ).and_return false
    end
    
    it "passes the url to the status checker" do
      $terminal.should_receive( :agree ).
        with( CruiseStatus::Command::DEFAULT_PROMPT ).
        and_return true
      CruiseStatus.should_receive( :new ).with( "url" ).and_return @status

      CruiseStatus::Command.run! %w[-p url]
    end

    it "prompts the user if the build has failed" do
      $terminal.should_receive( :agree ).
        with( CruiseStatus::Command::DEFAULT_PROMPT ).
        and_return true

      CruiseStatus::Command.run! %w[-p url]
      
      @output.string.should =~ /Build.*FAILURES/
    end
    
    it "returns 0 if the user enters 'y' at the prompt" do
      $terminal.should_receive( :agree ).
        with( CruiseStatus::Command::DEFAULT_PROMPT ).
        and_return true
      
      CruiseStatus::Command.run!( %w[-p url] ).should == 0
    end
    
    it "returns 1 if the user enters 'n' at the prompt" do
      $terminal.should_receive( :agree ).
        with( CruiseStatus::Command::DEFAULT_PROMPT ).
        and_return false
      
      CruiseStatus::Command.run!( %w[-p url] ).should == 1
    end
  end
end
