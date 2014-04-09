$stdin = File.new("/dev/null")


require "spec_helper"
require "explore/mortar/command/explore"
require "mortar/api"

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
    end
  
  end
end
