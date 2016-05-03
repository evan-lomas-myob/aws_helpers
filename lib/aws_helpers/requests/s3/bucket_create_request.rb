require 'aws_helpers/requests/request'
require 'aws_helpers/requests/polling_request'

module AwsHelpers
  module Requests
    module S3
      BucketCreateRequest = AwsHelpers::Requests::Request.new(
          :stdout,
          :bucket_name,
          :bucket_acl,
          :bucket_exists,
          :bucket_polling) do
        def initialize(values = {})
          super(values)
          self.bucket_polling ||= AwsHelpers::Requests::PollingRequest.new
        end
      end
    end
  end
end