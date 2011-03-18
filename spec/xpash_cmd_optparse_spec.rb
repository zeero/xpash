require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::CmdOptionParser do
  before do
    @foo = Foo.new
  end

  it "should parse args and should return option Hash." do
    @foo.foo(%w(foo bar -l)).should == {:long=>true}
    @foo.foo(%w(foo bar)).should == {}
    @foo.foo(%w(foo bar -s)).should == {:s=>true}
    @foo.foo(%w(foo -l -s bar)).should == {:s=>true, :long=>true}
    @foo.foo(%w(foo -l -a baz -s)).should == {:s=>true, :long=>true, :arg=>"baz"}
    lambda{@foo.foo(%w(foo -l -a baz -h))}.should raise_error(XPash::ReturnSignal)
  end

end

class Foo
  def optparse!(args)
    if ! @optp
      o = XPash::CmdOptionParser.new
      o.banner = "option parser test class"
      o.on("-l", "--long", "Long option")
      o.on("-s", "Short option")
      o.on("--arg arg", "With args option")
      @optp = o
    end
    @optp.parse!(args)
  end

  def foo(args)
    opts = optparse!(args)
  end
end

