require "explore/mortar/scraper/local/recommend"
require "spec_helper"

module Local
  describe Recommend do
    base_direc = "spec/fake"
    rec = nil
    before(:each) do
      rec = Recommend.new(base_direc)
    end

    describe "initialization" do
      it "sets directory" do
        rec.base_directory.should eq(base_direc)
        rec.delim_char.should eq("\t")
      end
    end

    describe "recommend" do
      it "returns the items for a given recommendation" do
        results = rec.get_recommendations('big', 'item_item_recs')
        results[:generic_item].length.should eq(5)
        results[:error].should eq(nil)
        results[:location].should eq("item_item_recs")
      end
    end
  end
end


