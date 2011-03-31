require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Frame, ".display" do
  before do
    @xpash = get_fixture
    prepare_stdout
    @io = StringIO.new
    $stdin = @io
  end

  it "should print default frame." do
    @io.puts ""
    @io.rewind
    XPash::Frame.display(@xpash)
    read_stdout.should == "xpash:/ > "
  end

  context "if sub command return some value" do
    it "should display the value with '=> '." do
      @io.puts "ls"
      @io.rewind
      XPash::Frame.display(@xpash)
      read_stdout.should =~ /^=\> 1$/
    end
  end

  context "if there is no input string" do
    it "should print frame again." do
      @io.puts
      @io.rewind
      XPash::Frame.display(@xpash)
      read_stdout.should == "xpash:/ > "
    end
  end

  context "if ReturnSignal is raised" do
    it "should do nothing. the process does not exit." do
      @io.puts "cd -h"
      @io.rewind
      lambda{XPash::Frame.display(@xpash)}.should_not raise_error(SystemExit)
    end
  end

  context "if RuntimeError is raised" do
    it "should display error message, but the process does not exit." do
      @io.puts "this_is_not_command"
      @io.puts "cd ///"
      @io.puts "grep"
      @io.puts "cd --this-is-not-option"
      @io.rewind
      XPash::Frame.display(@xpash)
      read_stdout.should =~ /Error: 'this_is_not_command' is not XPash command\.$/
      XPash::Frame.display(@xpash)
      read_stdout.should =~ /Error: Invalid expression: \/\/\//
      XPash::Frame.display(@xpash)
      read_stdout.should =~ /Error: Wrong number of arguments\. \(0 for 1\)/
      XPash::Frame.display(@xpash)
      read_stdout.should =~ /Error: invalid option: --this-is-not-option\. 'help COMMAND' may help you\./
    end
  end

end
