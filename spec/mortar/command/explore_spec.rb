require "explore/mortar/command/explore"
require "spec_helper"

module Mortar::Command
  describe Explore do
    before(:each) do
      stub_core
    end

    context( "explore") do
      it "shows appropriate error message" do
        stderr, stdout = execute("explore")
        stderr.should == <<-STDOUT
 !    Usage: mortar explore OUTPUT_DIRECTORY
 !    Must specify DIRECTORY.
STDOUT
      end

      it "shows appropriate error message" do
        stderr, stdout = execute("explore spec/fake/item_item_recs")
      end
    end
  
  end
end
