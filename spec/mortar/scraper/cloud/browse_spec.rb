require "explore/mortar/scraper/cloud/browse"
require "spec_helper"
require "s3_faker"

module Cloud
  describe Browse do
    browse = nil
    s3_path_success = "s3://good-bucket/key1"
    keys = [
      FakeObject.new("key1", true),
      FakeObject.new("direc/key2", true),
      FakeObject.new("direc/key3", true),
      FakeObject.new("direc/.hidden_key4", true),
      FakeObject.new("direc/another_direc/key", true)
    ]

    before(:each) do
      ENV["AWS_ACCESS_KEY"] = "foo"
      ENV["AWS_SECRET_KEY"] = "bar"
      buckets = [
        {:bucket => "good_bucket", :keys =>keys, :does_exist => true},
        {:bucket => "bad_bucket", :keys=> [], :does_exist => false}]
      stub_s3(buckets, ENV["AWS_ACCESS_KEY"], ENV["AWS_SECRET_KEY"])

    end

    context("success") do
      before(:each)do
        browse = Browse.new(s3_path_success)
      end
      it "should be initialized to have bucket, object key, delim_char and directory set" do
        browse.bucket.should eq('good-bucket')
        browse.object_key.should eq(keys[0].key)
        browse.base_directory.should eq(s3_path_success)
        browse.delim_char.should eq("\t")


      end

      it "should be able to initialize directories" do

        browse_two = Browse.new("s3://spec/fake")
        browse_three = Browse.new("s3://spec/fake/")
        
        browse_two.bucket.should eq('spec')
        browse_two.object_key.should eq('fake')

        browse_three.bucket.should eq('spec')
        browse_three.object_key.should eq('fake/')

      end

#      it "should find a bucket" do
#       browse.get_bucket.should eq(buckets[0])
#      end
#
#      it "should return the first file if object is directory" do
#        #TODO
#      end
#
#      it "should return the object if object is the file" do
#        browse.object_key = fake_s3_object.key 
#        browse.get_s3_object(fake_bucket_success).should eq(fake_s3_object)
#      end
#
#    end
#    context("failure") do
#      before(:each) do
#        browse = Browse.new(s3_bucket_fail)
#        stub_cloud(fake_bucket_fail)
#      end
#
#      it "should not find a bucket and return nil other wise" do 
#        browse.get_bucket.should eq(nil)
#      end
#
#      it "should return an error if bucket does not exist" do
#        browse_results = {
#          :error => "Specified bucket #{fake_bucket_fail.bucket} does not exist."
#        }
#        browse.browse(0).should eq(browse_results)
#      end
    end
  end
end
