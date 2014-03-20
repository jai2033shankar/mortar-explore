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
        results = {
          :item_item_recs => get_all_item_item[0..4],
          :user_item_recs => [],
          :location => "item_item_recs",
          :error => nil
        }
        rec.get_recommendations('big', 'item_item_recs').should eq(results)
      end
    end
  end
end


