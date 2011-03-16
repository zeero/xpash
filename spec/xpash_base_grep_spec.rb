require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "grep command" do
  before do
    @xpash = get_fixture
    prepare_stdout
  end

  it "should show list of found elements by searching text node\n\s\s" +
     "in current @list. (Found elements should be represented\n\s\s" +
     "with current query and their XPath expression.)" do
    @xpash.cd("//div")
    @xpash.grep("Your")

    stdout = read_stdout
    stdout.should =~ /'Your title'/
    stdout.should =~ /'Your article heading'/
    stdout.should_not =~ /'Your HTML5 project is almost ready! Please check the '/
  end

  it "should return number of found elements." do
    @xpash.grep("Your").should == 3
  end

  it "should raise 'ArgumentError('wrong number of arguments (0 for 1)')'," +
     "\n\s\sif user don't give keyword."
  it "with 2nd argument, should search from query added 2nd argument to current query."
  it "with '-a' option, should search in document"
  it "with '-c' option, should also show children of found elements"

end
