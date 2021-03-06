require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base do
  before do
    @xpash = get_fixture
    prepare_stdout
  end

  it "should has '/' as @query, default." do
    @xpash.query.should == "/"
  end

  it "should has Document in @list, default." do
    @xpash.ls.should == 1
    read_stdout.should =~ /html/
  end

  it "should fetch Document over http." do
    xpash = XPash::Base.new("http://www.ruby-lang.org/")
    xpash.query.should == "/"
    xpash.ls.should == 1
    read_stdout.should =~ /html/
  end

end

describe XPash::Base, "#getPath" do
  before do
    @xpash = get_fixture
  end

  it "should return xpath expression concatinating 2 args with '/'." do
    @xpash.getPath("//div/footer", "h3").should == "//div/footer/h3"
  end

  it "should omit prefix './' and suffix '/', but should not omit prefix './/'." do
    @xpash.getPath("//div/footer", "./h3").should == "//div/footer/h3"
    @xpash.getPath("//div/footer", ".//h3").should == "//div/footer/.//h3"
    @xpash.getPath("//div/footer", "./").should == "//div/footer"
    @xpash.getPath("//div/footer", ".//").should == "//div/footer/.//"
  end

  it "should deal prefix '/' as go root path sign." do
    @xpash.getPath("//div/footer", "/").should == "/"
    @xpash.getPath("//div/footer", "/html").should == "/html"
    @xpash.getPath("//div/footer", "//").should == "//"
    @xpash.getPath("//div/footer", "//p").should == "//p"
  end

  it "should deal prefix '..' as go up sign repeatedly." do
    @xpash.getPath("//div/footer/h3", "..").should == "//div/footer"
    @xpash.getPath("//div/footer/h3", "../").should == "//div/footer"
    @xpash.getPath("//div/footer/h3", "..//").should == "//div/footer//"
    @xpash.getPath("//div/footer/h3", "../..").should == "//div"
    @xpash.getPath("//div/footer/h3", "../../").should == "//div"
    @xpash.getPath("//div/footer/h3", "..//../").should == "//div/footer//.."
    @xpash.getPath("//div/footer/h3", "../../header").should == "//div/header"
    @xpash.getPath("//div/footer/h3", "../..//header").should == "//div//header"
    @xpash.getPath("//div/footer/img[@src=\"../img/test.png\"]", "..").should == "//div/footer"
    @xpash.getPath("//div[@foo=\"bar/baz\"]/footer/img[@src=\"../img/test.png\"]", "..").should == "//div[@foo=\"bar/baz\"]/footer"
    # invalid expression
    @xpash.getPath("//div/footer/h3", "...").should == "//div/footer/h3/..."
    @xpash.getPath("//div/footer/h3", "../[@id=\"test\"]").should == "//div/footer/[@id=\"test\"]"
  end

  it "should deal prefix '[' as add condition sign" do
    @xpash.getPath("//div", '[@class="test" and @id="test"]').should == '//div[@class="test" and @id="test"]'
  end

  it "should return current path, when 2nd argument is '.'" do
    @xpash.getPath("//div/footer", ".").should == "//div/footer"
    @xpash.getPath("//div/footer", "../.").should == "//div/."
  end

  it "should return default path, when 2nd argument is not given" do
    @xpash.getPath("//div/footer", "").should == "/"
  end

  it "should deal prefix and suffix '\"' and ''' \n\s\s" +
     "as ignore sign about other specs." do
    @xpash.getPath("//div", "\"/..\"").should == "//div/.."
    @xpash.getPath("//div", "\'/..\'").should == "//div/.."
    @xpash.getPath("//div", "\"//p\"").should == "//div//p"
    @xpash.getPath("//div", "\"/foo bar\"").should == "//div/foo bar"
    @xpash.getPath("//div", %q("/foo\sbar/")).should == "//div/foo bar/"
    @xpash.getPath("//div", %q('/foo\sbar/')).should == "//div/foo\\sbar/"
  end

end

describe XPash::Base, "#initialize_xmlns" do
  before do
    prepare_stdout
    @xpash = get_fixture("default.xml")
  end

  it "should create xml namespace map." do
    $xmlns["xml"].should == "http://www.w3.org/XML/1998/namespace"
    $xmlns["foo"].should == "http://foo.com/"
    $xmlns["xmlns"].should == "http://alicesautoparts.com/"
    $xmlns["xmlns.1"].should == "http://bobsbikes.com/"
    $xmlns["xmlns.2"].should == "http://foobarbaz.com/"
  end

  context "if document has duplicate prefix and defferent url for xml namespace" do
    it "should display warning message." do
      read_stdout.should == "Warning: XML namespace 'foo' is duplicate.\n"
    end
  end
end

