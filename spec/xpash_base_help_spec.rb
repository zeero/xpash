require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "help command" do
  before do
    @xpash = XPash::Base.new("#{File.dirname(__FILE__)}/../work/test.html")
  end

  it "should parse 'ls' command args" do
    args = %w(foo bar -s)
    opts = @xpash.optparse_ls!(args)
    opts.should == {:s => true}
    args.should == ["foo", "bar"]
  end

end
