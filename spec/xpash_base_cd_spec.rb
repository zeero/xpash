require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "cd command" do
  before do
    @xpash = XPash::Base.new("#{File.dirname(__FILE__)}/../work/test.html")
  end

  it "should return number of found elements." do
    @xpash.cd("div").should == 3
  end

  it "should add '/' and input query to @query." do
    @xpash.cd("div")
    @xpash.cd("article")
    @xpash.query.should == "//div/article"
  end

  it "should not add '/', but should add just input query,\n\s\s" +
     "when current @query ends with '/'." do
    @xpash.cd("/")
    @xpash.cd("html").should == 1
    @xpash.query.should == "/html"
  end

  it "when input starts with '..', should change @query to upper path." do
    @xpash.cd("div")
    @xpash.cd("article")
    @xpash.cd("..").should == 3
    @xpash.query.should == "//div"
  end

  it "when input starts with '/', should replace @query with input query." do
    @xpash.cd("/")
    @xpash.cd("..").should == 1
    @xpash.query.should == "/"
  end

  it "when input starts with '[', should add just input query." do
    @xpash.cd("div")
    @xpash.cd('[@class="wrapper" and @id="main"]').should == 1
    @xpash.query.should == '//div[@class="wrapper" and @id="main"]'
  end

end
