require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'xpash/cli'

describe XPash::CLI, "start" do
  before(:each) do
    @stdout_io = StringIO.new
    $stdout = @stdout_io
  end

  it "should print default frame." do
    pending "Researching how to test module using STDIN..."

    begin
      XPash::CLI.start()
    rescue SystemExit
    end
    @stdout_io.rewind
    @stdout = @stdout_io.read
    @stdout.should =~ /xpash:\/\/ > /
  end

  it "with '-h' option, should print help message and exit." do
    begin
      XPash::CLI.start(%w(-h))
    rescue SystemExit => e
      e.should be_a_kind_of SystemExit
    end
    @stdout_io.rewind
    @stdout = @stdout_io.read
    @stdout.should =~ /Usage/
    @stdout.should =~ /Options are/
  end

  it "with '-v' option, should print 'MODULE_NAME VERSION' and exit." do
    begin
      XPash::CLI.start(%w(-v))
    rescue SystemExit => e
      e.should be_a_kind_of SystemExit
    end
    @stdout_io.rewind
    @stdout = @stdout_io.read
    @stdout.should =~ /XPash 0.0.1/
  end

end
