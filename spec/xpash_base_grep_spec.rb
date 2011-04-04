require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "grep command" do
  before do
    @xpash = get_fixture
    prepare_stdout
  end

  it "should show list of found elements by searching text node\n\s\s" +
     "in current list. (Found elements should be represented\n\s\s" +
     "with current query and their XPath expression.)" do
    @xpash.cd("//div")
    @xpash.grep("Your")

    stdout = read_stdout
    stdout.should =~ %r(//div/header/h1/text\(\)\[.='Your title'\])
    stdout.should =~ %r(//div/article/header/h2/text\(\)\[.='Your article heading'\])
    stdout.should_not =~ /'Your HTML5 project is almost ready! Please check the '/
  end

  it "should return number of found elements." do
    @xpash.grep("Your").should == 3
  end

  context "when user don't give keyword." do
    it "should raise 'ArgumentError('wrong number of arguments (0 for 1)')'" do
      lambda{@xpash.grep()}.should raise_error(ArgumentError)
    end
  end

  context "when 2nd argument is given" do
    it "should search from query added 2nd argument to current query." do
      @xpash.cd("//div")
      @xpash.grep("Your", "article").should == 1

      stdout = read_stdout
      stdout.should_not =~ /'Your title'/
        stdout.should =~ %r(//div/article/header/h2/text\(\)\[.='Your article heading'\])
      stdout.should_not =~ /'Your HTML5 project is almost ready! Please check the '/
    end
  end

  context "if 2nd argument evaluation is not nodeset" do
    it "should return result value." do
      @xpash.grep("test", "//@class='no-js'").should == true
    end
  end

  context "when there is xml namespace" do
    it "should accept namespace specification in 2nd argument." do
      xpash = get_fixture("default.xml")
      xpash.grep("baz", "//xmlns.2:inventory").should == 2
      read_stdout.should =~ %r(//xmlns.2:inventory/foo:tire/text\(\)\[\.='baz'\])
    end
  end

  context "with '-a' option" do
    it "should search from document." do
      @xpash.cd("//div")
      @xpash.grep("-a", "Your").should == 3

      stdout = read_stdout
      stdout.should =~ /'Your title'/
        stdout.should =~ /'Your article heading'/
        stdout.should =~ /'Your HTML5 project is almost ready! Please check the '/
    end
  end

  context "with '-s, --short' option" do
    it "should display short XPath expression." do
      @xpash.cd("//div")
      @xpash.grep("-s", "Your").should == 2

      stdout = read_stdout
      stdout.scan(/text\(\)/).size.should == 2
      stdout.should_not =~ /'Your title'/
        stdout.should_not =~ /'Your article heading'/
    end
  end

end
