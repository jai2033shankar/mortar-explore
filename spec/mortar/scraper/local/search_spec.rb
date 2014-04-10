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
      it "finds all rows with searched string" do
        results = search.search(query)
        results[:generic_item].length.should eq(1)
        results[:error].should eq(nil)
      end
    end
    describe "searching both" do
      query = "toy story"
      it "finds all rows with searched string" do
        results = search.search(query)
        results[:generic_item].length.should eq(2)
        results[:error].should eq(nil)
      end
    end

    describe "search returns nothing found error" do
      it "gives error" do
        results = search.search('foo') 
        results[:error].should eq('Search string found nothing.  Please specify again')
      end

    end

  end
end
