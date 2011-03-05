require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "grep command" do
  before do
    @xpash = XPash::Base.new("#{File.dirname(__FILE__)}/../work/test.html")
  end

  it "should return list of found elements."
  it "should search current @list with inputed keyword for text value or attribute value."

end
