require "explore/mortar/local/browse"


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
    browse_results = {
       :item_item_recs => [
         {:type=>"item_item", :raw_weight=>"3.5342972", :item_A=>"big", :weight=>"6.208612", :file=>"spec/fake/item_item_recs", :rank=>"1", :item_B=>"the wizard of oz", :line=>"1"}, 
         {:type=>"item_item", :raw_weight=>"3.970611", :item_A=>"big", :weight=>"6.0058064", :file=>"spec/fake/item_item_recs", :rank=>"2", :item_B=>"peter pan", :line=>"2"}, 
         {:type=>"item_item", :raw_weight=>"3.833774", :item_A=>"big", :weight=>"5.896059", :file=>"spec/fake/item_item_recs", :rank=>"3", :item_B=>"snow white", :line=>"3"}, 
         {:type=>"item_item", :raw_weight=>"4.8948455", :item_A=>"big", :weight=>"5.5231767", :file=>"spec/fake/item_item_recs", :rank=>"4", :item_B=>"toy story", :line=>"4"}, 
         {:type=>"item_item", :raw_weight=>"5.81908", :item_A=>"big", :weight=>"4.407944", :file=>"spec/fake/item_item_recs", :rank=>"5", :item_B=>"mary poppins", :line=>"5"} 
      ],
       :user_item_recs => [] 
    }
    it "returns 5 rows from 0" do
      browse.browse( quantity, index,recommendations).should eq(browse_results)
      browse.index.should eq(6)
    end
  end

end
