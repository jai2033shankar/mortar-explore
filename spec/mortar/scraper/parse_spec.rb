#
# Copyright 2014 Mortar Data Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
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

require "explore/mortar/scraper/parse"
include Parse
describe "generic functions" do
  it "should parse out generic entries" do
    arr = Array.new
    row_data= "hello\twelcome".split("\t")
    search_data = ['my-file', 1]
    Parse.parse_generic_item(row_data, search_data, arr)
    res = arr[0]
    res["file"].should eq('my-file')
    res["line"].should eq(1)
    res["column1"].should eq("hello")
    res["column2"].should eq("welcome")
  end
end
