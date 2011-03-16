require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base, "help command" do
  before do
    @xpash = XPash::Base.new("#{File.dirname(__FILE__)}/../work/test.html")
  end
end
