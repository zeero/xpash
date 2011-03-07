require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "grep command" do
  before do
    @xpash = XPash::Base.new("#{File.dirname(__FILE__)}/../work/test.html")
  end

  it "should show list of found elements by searching text node in current @list."
  it "should return number of found elements."

end
