require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers'

describe AwsHelpers::Actions::S3 do

  config = AwsHelpers::Config.new({})
  no_bucket = 'non-existent-bucket'

  describe '#stack_exists?' do

    it 'should check if the s3 exists' do
      expect(s3_exists?(config, no_bucket)).to eq(false)
    end

    # it 'should check the s3 bucket location' do
    #   s3_location(config, s3_bucket_name)
    # end
    #
    # it 'should return the s3 bucket url' do
    #   s3_url(config, s3_bucket_name)
    # end

  end

  private

  def s3_exists?(config, s3_bucket_name)
    AwsHelpers::Actions::S3::S3Exists.new(config, s3_bucket_name).execute
  end

  def s3_location(config, s3_bucket_name)
    client = config.aws_s3_client
    begin
      client.get_bucket_location(bucket: s3_bucket_name).data.location_constraint
    rescue Aws::S3::Errors::NoSuchBucket
      puts "Cannot find bucket named #{s3_bucket_name}"
    end
  end

  def s3_url(config, s3_bucket_name)
    client = config.aws_s3_client
    # begin
    url = Aws::S3::Bucket.new(s3_bucket_name, client: client).url
    puts url
    # rescue Aws::S3::Errors::NoSuchBucket
    #   puts "Cannot find bucket named #{s3_bucket_name}"
    # end
  end

end
