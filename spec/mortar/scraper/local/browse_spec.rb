require "explore/mortar/scraper/local/browse"
require 'ruby-debug'

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
      all_item_item_recs = [
            {:type=>"item_item", :weight=>"6.208612", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"3.5342972", :line=>"1", :item_A=>"big", :rank=>"1", :item_B=>"the wizard of oz"}, 
            {:type=>"item_item", :weight=>"6.0058064", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"3.970611", :line=>"2", :item_A=>"big", :rank=>"2", :item_B=>"peter pan"},
            {:type=>"item_item", :weight=>"5.896059", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"3.833774", :line=>"3", :item_A=>"big", :rank=>"3", :item_B=>"snow white"},
            {:type=>"item_item", :weight=>"5.5231767", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"4.8948455", :line=>"4", :item_A=>"big", :rank=>"4", :item_B=>"toy story"}, 
            {:type=>"item_item", :weight=>"4.407944", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"5.81908", :line=>"5", :item_A=>"big", :rank=>"5", :item_B=>"mary poppins"}, 
            {:type=>"item_item", :weight=>"3.9243095", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"8.266502", :line=>"6", :item_A=>"antz", :rank=>"1", :item_B=>"the lion king"},
            {:type=>"item_item", :weight=>"3.7120519", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"7.348985", :line=>"7", :item_A=>"antz", :rank=>"2", :item_B=>"honey i shrunk the kids"},
            {:type=>"item_item", :weight=>"3.2631755", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"1.3863515", :line=>"8", :item_A=>"antz", :rank=>"3", :item_B=>"a connecticut yankee in king arthur's court"},
            {:type=>"item_item", :weight=>"3.1456258", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"4.5953684", :line=>"9", :item_A=>"antz", :rank=>"4", :item_B=>"heaven can wait"},
            {:type=>"item_item", :weight=>"3.1211402", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"3.5740905", :line=>"10", :item_A=>"antz", :rank=>"5", :item_B=>"who killed roger rabbit?"},
            {:type=>"item_item", :weight=>"3.2222044", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"4.5953684", :line=>"11", :item_A=>"alien", :rank=>"1", :item_B=>"psycho"},
            {:type=>"item_item", :weight=>"2.986917", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"4.8948455", :line=>"12", :item_A=>"alien", :rank=>"2", :item_B=>"i know what you did last summer"},
            {:type=>"item_item", :weight=>"2.8968637", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"5.500517", :line=>"13", :item_A=>"alien", :rank=>"3", :item_B=>"nightmare on elm street"},
            {:type=>"item_item", :weight=>"2.873042", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"6.580674", :line=>"14", :item_A=>"alien", :rank=>"4", :item_B=>"tremors"},
            {:type=>"item_item", :weight=>"2.7485006", :file=>"spec/fake/item_item_recs/part-r-00000", :raw_weight=>"5.65644", :line=>"15", :item_A=>"alien", :rank=>"5", :item_B=>"scream"}
        ]

      
      it "returns 5 rows from 0 with no error message" do
        browse_results = {
          :item_item_recs => all_item_item_recs[0..4],
          :user_item_recs => [],
          :location => "item_item_recs",
          :error => nil 
        }
        browse.browse( quantity, index,recommendations).should eq(browse_results)
        browse.index.should eq(6)
      end

      it "returns 5 rows from 5" do
        browse_results = {
          :item_item_recs => all_item_item_recs[4..8],
          :user_item_recs => [],
          :location => "item_item_recs",
          :error => nil 
        }
        results = browse.browse(5, 5, recommendations)
        results.should eq(browse_results)
        results[:item_item_recs].length.should eq(5)
        
      end
      it "returns 15 rows when requesting 20 because it reached file limit" do
        browse_results = {
          :item_item_recs => all_item_item_recs, 
          :user_item_recs => [],
          :location => "item_item_recs",
          :error => nil 
        }
        browse.browse( 20, 1,recommendations).should eq(browse_results)
        browse.index.should eq(16)
      end

      it "returns 5 rows when called by specific file" do
        browse_results = {
          :item_item_recs => all_item_item_recs[0..4],
          :user_item_recs => [],
          :location => "item_item_recs/part-r-00000",
          :error => nil
        }
        browse.browse( 5, index, 'item_item_recs/part-r-00000').should eq(browse_results)
      end


      it "returns an error message that Directory/File does not exit" do
        results = browse.browse(20,1, "fake file")
        results[:error].should eq("The requested directory or file, spec/fake/fake file, does not exist.  Please specify again.")
      end

      
    end

  end
end
