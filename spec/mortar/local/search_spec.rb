require "explore/mortar/local/search"


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

  describe "searching" do
    query = "scream"
    grep_query = "grep -r #{query} #{base_direc} -n"
    query_results = [{:raw_weight=>"5.65644", :rank=>"5", :weight=>"2.7485006", :fieldA=>"alien", :fieldB=>"scream"}] 
    it "finds all rows with searched string" do
      search.search(query).should eq(query_results)
    end
  end

end
