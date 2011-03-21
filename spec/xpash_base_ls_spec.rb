require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "ls command" do
  before do
    @xpash = get_fixture
    prepare_stdout
  end

  it "should show top level elements in @list." do
    @xpash.cd("//div")
    @xpash.ls
    stdout = read_stdout
    stdout.should =~ %r(//div\[@id="header-container"\]:)
    stdout.should =~ %r(//div\[@class="wrapper" and @id="main"\]:)
    stdout.should =~ %r(//div\[@id="footer-container"\]:)
  end

  it "should also show its child, if element has child.\n\s\s" +
     "Then, element is marked with ':'." do
    @xpash.cd('//div[@class="wrapper" and @id="main"]')
    @xpash.ls
    stdout = read_stdout
    stdout.should =~ %r(//div\[@class="wrapper" and @id="main"\]:\n)
    stdout.should =~ %r(text\(\)\[\.='\\n\t\t'\])
    stdout.should =~ %r(aside)
    stdout.should =~ %r(article)
  end

  it "with argument, should show element from added position current query and argument." do
    @xpash.cd('//div[@id="header-container"]')
    @xpash.ls("header")
    stdout = read_stdout
    stdout.should =~ %r(//div\[@id="header-container"\]/header\[@class="wrapper"\]:\n)
    stdout.should =~ %r(h1\[@id="title"\])
    stdout.should =~ %r(text\(\)\[\.='\\n\t\t\t'\])
    stdout.should =~ %r(nav)
  end

  it "in root path, should return top level elements." do
    @xpash.cd("")
    @xpash.ls
    stdout = read_stdout
    stdout.should =~ /html/
  end

  it "with '-s, --short' option, should display short XPath expression." do
    @xpash.cd('//div[@class="wrapper" and @id="main"]')
    @xpash.ls("--short")
    stdout = read_stdout
    stdout.should == "//div:\ntext()\naside\ntext()\narticle\ntext()\n\n"
  end

  it "with '-h, --help' option, should show help message." do
    lambda{@xpash.ls("-h")}.should raise_error(XPash::ReturnSignal)
    stdout = read_stdout
    stdout.should =~ /Usage: /
  end

end

describe XPash::Base, "#optparse_ls!" do
  before do
    @xpash = get_fixture
  end

  it "should parse 'ls' command arguments." do
    args = %w(foo bar -s)
    opts = @xpash.optparse_ls!(args)
    opts.should == {:short => true}
    args.should == ["foo", "bar"]
  end

end
