require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base do
  before do
    @xpash = get_fixture
  end

  it "should has '//' as @query, default." do
    @xpash.query.should eql "//"
  end

  it "should has Document in @list, default."

end

describe XPash::Base, "#getPath" do

  it "should return xpath expression concatinating 2 args with '/'."

  it "should deal prefix '/' as go root path sign."

  it "should deal prefix '..' as go up sign repeatedly." do
    getPath("//div/footer", "h3").should == "//div/footer/h3"
    getPath("//div/footer", "./h3").should == "//div/footer/h3"
    getPath("//div/footer", ".//h3").should == "//div/footer/.//h3"
    getPath("//div/footer/h3", "..").should == "//div/footer"
    getPath("//div/footer/h3", "../").should == "//div/footer"
    getPath("//div/footer/h3", "../..").should == "//div"
    getPath("//div/footer/h3", "../../").should == "//div"
    getPath("//div/footer/h3", "..//../").should == "//div/footer//.."
    getPath("//div/footer/h3", "../../header").should == "//div/header"
    getPath("//div/footer/h3", "../..//header").should == "//div//header"
  end

  it "should deal prefix and suffix '\"' and ''' as ignore sign about other specs."

  it "should has Document in @list, default."

end
