require 'aws-sdk-core'
require 'aws_helpers'

describe AwsHelpers::S3 do
  bucket_name = 'aws-helpers-test-bucket'

  after(:all) do
    Aws::S3::Client.new.delete_bucket(bucket: bucket_name)
  end

  it 'should create the bucket and it should then exist' do
    s3 = described_class.new
    s3.bucket_create(bucket_name)
    expect(s3.bucket_exists?(bucket_name)).to be_truthy
  end

end
