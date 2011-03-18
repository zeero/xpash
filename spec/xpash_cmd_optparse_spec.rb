require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::CmdOptionParser do
  before do
    @foo = Foo.new
    prepare_stdout
  end

  it "should parse args and should return option Hash." do
    @foo.foo(%w(foo bar -l)).should == {:long=>true}
    @foo.foo(%w(foo bar)).should == {}
    @foo.foo(%w(foo bar -s)).should == {:s=>true}
    @foo.foo(%w(foo -l -s bar)).should == {:s=>true, :long=>true}
    @foo.foo(%w(foo -l -a baz -s)).should == {:s=>true, :long=>true, :arg=>"baz"}
  end
  it "with '-h' or '--help' option, should display help message\n\s\s" +
     "and raise XPash::ReturnSignal, but no SystemExit." do
    lambda{@foo.foo(%w(foo -a baz -h))}.should raise_error(XPash::ReturnSignal)
    stdout = read_stdout
    stdout.should =~ /[^\n]\n\s{4}-h, --help       Show this help message\.\n/
  end

  it "with '-v' or '--version' option, should not parse valid option" +
     "\n\s\sin default." do
    lambda{@foo.foo(%w(foo -l -v))}.should raise_error(OptionParser::InvalidOption)
  end

  it "'#describe' should show message with indent." do
    lambda{@foo.foo(%w(foo -a baz -h))}.should raise_error(XPash::ReturnSignal)
    stdout = read_stdout
    stdout.should =~ /[^\n]\n\s{4}#{Foo::Description}\n/
  end

  it "'#separate' should show message with indent." do
    lambda{@foo.foo(%w(foo --help))}.should raise_error(XPash::ReturnSignal)
    stdout = read_stdout
    stdout.should =~ /[^\n]\n\n#{Foo::Separator}\n/
  end

end

class Foo
  Description = "This is desribe sample."
  Separator = "Options:"

  def optparse!(args)
    unless @optp
      o = XPash::CmdOptionParser.new
      o.banner = "option parser test class"
      o.separator Separator
      o.on("-l", "--long", "Long option")
      o.on("-s", "Short option")
      o.on("--arg arg", "With args option")
      o.separator "Description:"
      o.describe Description
      @optp = o
    end
    @optp.parse!(args)
  end

  def foo(args)
    opts = optparse!(args)
  end
end

