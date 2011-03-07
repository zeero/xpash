require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "grep command" do
  before do
    @xpash = XPash::Base.new("#{File.dirname(__FILE__)}/../work/test.html")
  end

  it "should show list of found elements by searching text node\n\s\s" +
     "in current @list."
  it "should return number of found elements."
  it "should raise 'ArgumentError('wrong number of arguments (1 for 2)')'," +
     "\n\s\sif user don't give keyword."

end
