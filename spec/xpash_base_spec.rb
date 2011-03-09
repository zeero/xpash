require File.dirname(__FILE__) + '/spec_helper.rb'

describe XPash::Base do
  before do
    @xpash = get_fixture
  end

  it "should has '//' as @query, default." do
    @xpash.query.should eql "//"
  end

  it "should has Document in @list, default."

end
