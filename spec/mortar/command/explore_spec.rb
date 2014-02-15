#
# Copyright 2014 Mortar Data Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
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
