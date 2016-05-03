require 'aws_helpers/requests/request'

module AwsHelpers
  module Requests
    module S3
      BucketExistsRequest = AwsHelpers::Requests::Request.new(:bucket_name, :bucket_exists)
    end
  end
end