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
require "explore/mortar/scraper/local/browse"

module Local
  describe Browse do
    base_direc = "spec/fake"
    browse  = nil
    before(:each) do
      browse = Browse.new(base_direc)
    end

    describe "initialization" do
      
      it "sets directory" do
        browse.base_directory.should eq(base_direc)
        browse.delim_char.should eq("\t")
      end
    end

    describe "browsing" do
      index = 1 
      quantity = 5
      recommendations = 'item_item_recs'

      
      it "returns 5 rows from 0 with no error message" do
        results = browse.browse( quantity, index,recommendations)
        results[:generic_item].length.should eq(5)
        results[:location].should eq("item_item_recs")
        results[:error].should eq(nil)
        browse.index.should eq(6)
      end

      it "returns 5 rows from 5" do
        results = browse.browse( quantity, index,recommendations)
        results[:generic_item].length.should eq(5)
        
        results[:location].should eq("item_item_recs")
        results[:error].should eq(nil)
      end
      it "returns 15 rows when requesting 20 because it reached file limit" do
        results = browse.browse( 20, 1,recommendations)
        results[:generic_item].length.should eq(15)
        browse.index.should eq(16)
        results[:error].should eq(nil)
        results[:location].should eq("item_item_recs")
      end

      it "returns 5 rows when called by specific file" do
        results = browse.browse( 5, index, 'item_item_recs/part-r-00000')
        results[:generic_item].length.should eq(5)
        results[:location].should eq("item_item_recs/part-r-00000")
        results[:error].should eq(nil)
        
      end


      it "returns an error message that Directory/File does not exit" do
        results = browse.browse(20,1, "fake file")
        results[:error].should eq("The requested directory or file, spec/fake/fake file, does not exist.  Please specify again.")
      end

      
    end

  end
end
