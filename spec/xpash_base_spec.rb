require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base do
  before do
    @xpash = get_fixture
    prepare_stdout
  end

  it "should has '/' as @query, default." do
    @xpash.query.should eql "/"
  end

  it "should has Document in @list, default." do
    @xpash.ls.should == nil
    read_stdout.should eql ""
  end

end

describe XPash::Base, "#getPath" do
  before do
    @xpash = get_fixture
  end

  it "should return xpath expression concatinating 2 args with '/'." do
    @xpash.getPath("//div/footer", "h3").should == "//div/footer/h3"
    @xpash.getPath("//div/footer", "./h3").should == "//div/footer/h3"
    @xpash.getPath("//div/footer", ".//h3").should == "//div/footer/.//h3"
    @xpash.getPath("//div/footer", "").should == "/"
    @xpash.getPath("//div/footer", ".").should == "//div/footer"
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
    @xpash.getPath("//div/footer/h3", "...").should == "//div/footer/h3/..."
    @xpash.getPath("//div/footer/h3", "../[@id=\"test\"]").should == "//div/footer/[@id=\"test\"]"
  end

  it "should deal prefix and suffix '\"' and ''' \n\s\s" +
     "as ignore sign about other specs." do
    @xpash.getPath("//div", "\"..\"").should == "//div/.."
    @xpash.getPath("//div", "\'..\'").should == "//div/.."
    @xpash.getPath("//div", "\"foo bar\"").should == "//div/foo bar"
    @xpash.getPath("//div", "\"foo\sbar\/\"").should == "//div/foo bar/"
  end

end
