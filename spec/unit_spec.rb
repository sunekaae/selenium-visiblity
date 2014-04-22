require "rubygems"
require "awesome_print"

describe "simple units always passes" do
  it "always passes", :unit => true do
    1.should == 1
  end
end
