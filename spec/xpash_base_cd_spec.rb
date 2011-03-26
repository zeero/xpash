require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "cd command" do
  before do
    @xpash = get_fixture
    prepare_stdout
  end

  it "should return number of found elements." do
    @xpash.cd("//div").should == 3
  end

  it "should add '/' and input query to @query." do
    @xpash.cd("//div")
    @xpash.cd("article")
    @xpash.query.should == "//div/article"
  end

  context "if result is empty" do
    it "should raise error." do
      lambda{@xpash.cd("//test")}.should raise_error(RuntimeError)
    end
  end

  context "when current @query ends with '/'." do
    it "should not add '/', but should add just input query" do
      @xpash.cd("html").should == 1
      @xpash.query.should == "/html"
    end
  end

  context "when input starts with '..'" do
    it "should change @query to upper path." do
      @xpash.cd("//div")
      @xpash.cd("article")
      @xpash.cd("..").should == 3
      @xpash.query.should == "//div"
    end
  end

  context "when input starts with '/'" do
    it "should replace @query with input query." do
      @xpash.cd("/")
      @xpash.cd("..").should == 1
      @xpash.query.should == "/"
    end
  end

  context "when input starts with '['" do
    it "should add just input query." do
      @xpash.cd("//div")
      @xpash.cd('[@class="wrapper" and @id="main"]').should == 1
      @xpash.query.should == '//div[@class="wrapper" and @id="main"]'
    end
  end

  context "when no input given" do
    it "should go to default path" do
      @xpash.cd("").should == 1
      @xpash.query.should == '/'
    end
  end

  context "when there is xml namespace" do
    it "should accept namespace specification" do
      xpash = get_fixture("default.xml")
      xpash.cd("/parts/xmlns:inventory").should == 1
      xpash.query == "/parts/xmlns:inventory > "
    end
  end

end
