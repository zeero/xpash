require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::CmdOptionParser do
  before do
    @foo = Foo.new
    prepare_stdout
  end

  it "should parse args and should return option Hash." do
    @foo.foo(%w(foo bar -l)).should == {:long => true}
    @foo.foo(%w(foo bar)).should == {}
    @foo.foo(%w(foo bar -s)).should == {:s => true}
    @foo.foo(%w(foo -l -s bar)).should == {:s => true, :long => true}
    @foo.foo(%w(foo -l -a baz -s)).should == {:s => true, :long => true, :arg => "baz"}
  end

  context "(with '-h' or '--help' option)" do
    it "should display help message\n\s\s" +
     "and raise XPash::ReturnSignal, without SystemExit." do
      lambda{@foo.foo(%w(foo -a baz -h))}.should raise_error(XPash::ReturnSignal)
      stdout = read_stdout
      stdout.should =~ /[^\n]\n\s{4}-h, --help       Show this help message\.\n/
     end
  end

  context "with '-v' or '--version' option" do
    it "should not parse valid option" +
     "\n\s\sin default." do
      lambda{@foo.foo(%w(foo -l -v))}.should raise_error(OptionParser::InvalidOption)
     end
  end

  context "if min_args is set" do
    it "should check args length and should raise error with invalid args." do
      @foo.optp.min_args = 1
      lambda{@foo.foo}.should raise_error(ArgumentError)
    end
  end

  context "if default_opts is set" do
    it "should use default value if option is not set." do
      @foo.optp.default_opts = {:s => true}

      @foo.foo(%w(foo bar -l)).should == {:s => true, :long => true}
      @foo.foo(%w(foo bar)).should == {:s => true}

      @foo.optp.default_opts = {:arg => "foo"}

      @foo.foo(%w(foo bar)).should == {:arg => "foo"}
      @foo.foo(%w(foo -l bar)).should == {:arg => "foo", :long => true}
      @foo.foo(%w(foo -l -a baz -s)).should == {:s => true, :long => true, :arg => "baz"}
    end
  end

end

describe XPash::CmdOptionParser, "#describe" do
  before do
    @foo = Foo.new
    prepare_stdout
  end

  it "should show message with indent." do
    lambda{@foo.foo(%w(foo -a baz -h))}.should raise_error(XPash::ReturnSignal)
    stdout = read_stdout
    stdout.should =~ /[^\n]\n\s{4}#{Foo::Description}\n/
  end
end

describe XPash::CmdOptionParser, "#separate"  do
  before do
    @foo = Foo.new
    prepare_stdout
  end

  it "should show message with indent." do
    lambda{@foo.foo(%w(foo --help))}.should raise_error(XPash::ReturnSignal)
    stdout = read_stdout
    stdout.should =~ /[^\n]\n\n#{Foo::Separator}\n/
  end

end

class Foo
  attr_accessor :optp

  Description = "This is desribe sample."
  Separator = "Options:"

  def initialize
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

  def foo(args)
    opts = @optp.parse!(args)
  end
end

