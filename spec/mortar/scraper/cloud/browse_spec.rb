require "explore/mortar/scraper/cloud/browse"
require "spec_helper"
require "cloudspec_helper"
require "cloud_faker"

module Cloud
  describe Browse do
    browse = nil
    s3_bucket_success = 's3://spec/fake/item_item_recs/part-r-00000'
    s3_bucket_fail = 's3://fail/fake'
    s3_object_dir = "fake/item_item_recs"
    s3_object = s3_object_dir + "/part-r-00000"
    fake_s3_object = FakeObject.new(s3_object_dir, s3_object)
    fake_s3_dir_object = FakeObject.new(s3_object_dir, s3_object_dir)
    fake_bucket_success = FakeBucket.new('spec', fake_s3_object)
    fake_bucket_dir_success = FakeBucket.new('spec', fake_s3_dir_object)
    fake_bucket_fail = FakeBucket.new('fail')

    context("success") do
      before(:each) do
        browse = Browse.new(s3_bucket_success)
        stub_cloud(fake_bucket_success)
      end
      it "should be initialized to have bucket, object key, delim_char and directory set" do
        browse.bucket.should eq('spec')
        browse.object_key.should eq(s3_object)
        browse.base_directory.should eq(s3_bucket_success)
        browse.delim_char.should eq("\t")


      end

      it "should be able to initialize directories" do

        browse_two = Browse.new("s3://spec/fake")
        browse_three = Browse.new("s3://spec/fake/")
        
        browse_two.bucket.should eq('spec')
        browse_two.object_key.should eq('fake')

        browse_three.bucket.should eq('spec')
        browse_three.object_key.should eq('fake')

      end


      it "should find a bucket" do
        browse.get_bucket.should eq(fake_bucket_success)
      end

      it "should return the first file if object is directory" do
        #TODO
      end

      it "should return the object if object is the file" do
        browse.object_key = fake_s3_object.key 
        browse.get_s3_object(fake_bucket_success).should eq(fake_s3_object)
      end

      it "should browse through 5 contents" do
        #browse.browse(5, 1).should eq(1)

      end
    end
    context("failure") do
      before(:each) do
        browse = Browse.new(s3_bucket_fail)
        stub_cloud(fake_bucket_fail)
      end

      it "should not find a bucket and return nil other wise" do 
        browse.get_bucket.should eq(nil)

      end

      it "should return an error if bucket does not exist" do
        browse_results = {
          :error => "Specified bucket #{fake_bucket_fail.bucket} does not exist."
        }
        browse.browse(0).should eq(browse_results)
      end

      it "should return nil if object does not exist" do
      end

    end
  end

end
