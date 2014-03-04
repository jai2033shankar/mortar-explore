require "explore/mortar/scraper/local/search"

module Local
  describe Search do
    base_direc = "spec/fake"
    search  = nil
    before(:each) do
      search = Search.new(base_direc)
    end

    describe "initialization" do
      
      it "sets directory" do
        search.base_directory.should eq(base_direc)
        search.delim_char.should eq("\t")
      end
    end

    describe "searching only in item item recs" do
      query = "scream"
      query_results = {
        :item_item_recs => [{:file => "spec/fake/item_item_recs/part-r-00000",:raw_weight=>"5.65644",:type => "item_item", :line => "15", :rank=>"5", :weight=>"2.7485006", :item_A=>"alien", :item_B=>"scream"}],
        :user_item_recs => [],
        :error => nil 
      }
      it "finds all rows with searched string" do
        search.search(query).should eq(query_results)
      end
    end
    describe "searching both" do
      query = "toy story"
      query_results = {
        :item_item_recs => [{:type=>"item_item", :raw_weight=>"4.8948455", :weight=>"5.5231767", :file=>"spec/fake/item_item_recs/part-r-00000", :rank=>"4", :line=>"4", :item_A=>"big", :item_B=>"toy story"}],
        :user_item_recs => [{:type=>"user_item", :item_reason_item_weight=>"4.8948455", :weight=>"2.350144", :file=>"spec/fake/user_item_recs/part-r-00000", :rank=>"4", :line=>"4", :user=>"00d06ebf27cb429ba002a4966387ba2f", :item=>"toy story", :reason_item=>"big", :user_reason_item_weight=>"1.0"}],
        :error => nil 

      }
      it "finds all rows with searched string" do
        search.search(query).should eq(query_results)
      end
    end

    describe "search returns nothing found error" do
      query_results = {
        :item_item_recs => [],
        :user_item_recs => [],
        :error => 'Search string found nothing.  Please specify again'
      }
      it "gives error" do
        search.search('foo').should eq(query_results)
      end

    end

  end
end
