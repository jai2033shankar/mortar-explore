require 'rspec'
require 'rr'
require 'aws-sdk'

def stub_cloud(fake_bucket)
  any_instance_of(AWS::S3) do |s3|
    stub(s3).buckets.returns({fake_bucket.bucket => fake_bucket})
  end
end



