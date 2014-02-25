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
    index = 0 
    quantity = 5
    recommendations = 'item_item_recs'
    query_results = [{:raw_weight=>"5.65644", :rank=>"5", :weight=>"2.7485006", :fieldA=>"alien", :fieldB=>"scream"}] 
    it "returns 5 rows from 0" do
      #browse.browse(recommendations, index, quantity).should eq(query_results)
    end
  end

end
