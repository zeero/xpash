require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "ls command" do
  before do
    @xpash = get_fixture
    prepare_stdout
  end

  it "should show top level elements in current list." do
    @xpash.cd("//div")
    @xpash.ls("--long")
    stdout = read_stdout
    stdout.should =~ %r(//div\[@id='header-container'\]:)
    stdout.should =~ %r(//div\[@class='wrapper' and @id='main'\]:)
    stdout.should =~ %r(//div\[@id='footer-container'\]:)
  end

  it "should return number of found elements." do
    @xpash.ls("//div").should == 3
  end

  context "if element has child" do
    it "should also show its child and this element is marked with ':'." do
      @xpash.cd("//div[@class='wrapper' and @id='main']")
      @xpash.ls
      stdout = read_stdout
      stdout.should == "//div:\ntext()\naside\narticle\n\n"
    end
  end

  context "with argument" do
    it "should show element from added position current query and argument." do
      @xpash.cd("//div[@id='header-container']")
      @xpash.ls("-l", "header")
      stdout = read_stdout
      stdout.should =~ %r(//div\[@id='header-container'\]/header\[@class='wrapper'\]:\n)
      stdout.should =~ %r(h1\[@id='title'\])
      stdout.should =~ %r(text\(\)\[\.='\\n\t\t\t'\])
      stdout.should =~ %r(nav)
    end
  end

  context "if result is not nodeset" do
    it "should return result value." do
      @xpash.ls("//@class='no-js'").should == true
    end
  end

  context "if result is empty" do
    it "should raise error." do
      lambda{@xpash.ls("//test")}.should raise_error(RuntimeError)
    end
  end

  context "when in root path" do
    it "should return top level elements." do
      @xpash.cd("")
      @xpash.ls
      stdout = read_stdout
      stdout.should =~ /html/
    end
  end

  context "when there is xml namespace" do
    it "should accept namespace specification." do
      xpash = get_fixture("default.xml")
      xpash.ls("-l", "//xmlns.1:inventory").should == 1
      read_stdout.should =~ /\/\/xmlns.1:inventory:\ntext\(\)\[.='\\n    '\]\nxmlns.1:tire\ntext\(\)\[.='\\n    '\]\nxmlns.1:tire\ntext\(\)\[.='\\n  '\]\n\n/
    end
  end

  context "with '-l, --long' option" do
    it "should display long XPath expression." do
      @xpash.cd("//div[@class='wrapper' and @id='main']")
      @xpash.ls("--long")
      stdout = read_stdout
      stdout.should =~ %r(//div\[@class='wrapper' and @id='main'\]:\n)
      stdout.should =~ %r(text\(\)\[\.='\\n\t\t'\])
      stdout.should =~ %r(aside)
      stdout.should =~ %r(article)
    end
  end

  context "with '-h, --help' option" do
    it "should show help message." do
      lambda{@xpash.ls("-h")}.should raise_error(XPash::ReturnSignal)
      stdout = read_stdout
      stdout.should =~ /Usage: /
    end
  end

end

describe XPash::Base, "#optparse_ls!" do
  before do
    @xpash = get_fixture
  end

  it "should parse 'ls' command arguments." do
    args = %w(foo bar -l)
    opts = @xpash.optparse_ls!(args)
    opts.should == {:long => true}
    args.should == ["foo", "bar"]
  end

end
