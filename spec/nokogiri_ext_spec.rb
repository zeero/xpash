require File.dirname(__FILE__) + '/spec_helper.rb'

describe Nokogiri::XML::Node, "#ls (extended method)" do
  before do
    @doc = Nokogiri::HTML(open(FIXTURE_DIR + "/default.html"))
  end

  it "should return their name." do
    @doc.ls.should == ""
  end
end

describe Nokogiri::XML::Document, "#ls (extended method)" do
  before do
    @doc = Nokogiri::HTML(open(FIXTURE_DIR + "/default.html"))
  end

  it "should return empty String." do
    @doc.ls.should == ""
  end
end

describe Nokogiri::XML::Element, "#ls (extended method)" do
  before do
    @doc = Nokogiri::HTML(open(FIXTURE_DIR + "/default.html"))
    @elem = Nokogiri::XML::Element.new("h1", @doc)
    @elem['id'] = "foo"
    @elem['class'] = "bar"
    @elem.content = "baz"
  end

  it "should return XPath expression about itself include its attributes." do
    @elem.ls.should == 'h1[@class="bar" and @id="foo"]'
  end

  context "when opts[:short] set in args" do
    it "should return its tag name only." do
      @elem.ls({:short => true}).should == 'h1'
    end
  end

  context "when xml namespace is set" do
    it "should display xml namespace prefix" do
      doc = Nokogiri::XML(open(FIXTURE_DIR + "/default.xml"))
      $xmlns = {"xmlns" => "http://foobarbaz.com/", "foo" => "http://foo.com/"}
      doc.xpath("//xmlns:inventory", $xmlns)[0].ls.should == "xmlns:inventory"
      doc.xpath("//xmlns:inventory/foo:tire", $xmlns)[0].ls.should == "foo:tire"
    end
  end

end

describe Nokogiri::XML::Attr, "#ls (extended method)" do
  before do
    @doc = Nokogiri::HTML(open(FIXTURE_DIR + "/default.html"))
    @elem = Nokogiri::XML::Element.new("h1", @doc)
    @elem['id'] = "foo"
    @attr = @elem.attribute('id')
  end

  it "should return xpath expression about itself." do
    @attr.ls.should == "@id=\"foo\""
  end

end

describe Nokogiri::XML::Text, "#ls (extended method)" do
  before do
    @doc = Nokogiri::HTML(open(FIXTURE_DIR + "/default.html"))
    @elem = Nokogiri::XML::Text.new("foobarbaz", @doc)
  end

  it "should return xpath expression about itself." do
    @elem.ls.should == "text()[.='foobarbaz']"
  end
end

