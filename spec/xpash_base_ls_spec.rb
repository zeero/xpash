require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "ls command" do
  before do
    @xpash = get_fixture
    prepare_stdout
  end

  it "should show top level elements in @list." do
    @xpash.cd("div")
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
    stdout.should =~ %r(text\(\)\[\.="\t\t"\])
    stdout.should =~ %r(aside)
    stdout.should =~ %r(article)
  end

end
