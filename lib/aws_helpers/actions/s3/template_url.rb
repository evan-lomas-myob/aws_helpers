require 'aws_helpers/actions/s3/exists'

module AwsHelpers
  module Actions
    module S3
      class TemplateUrl
        def initialize(config, bucket_name)
          @config = config
          @client = @config.aws_s3_client
          @bucket_name = bucket_name
        end

        def execute
          if AwsHelpers::Actions::S3::Exists.new(@config, @bucket_name).execute
            bucket_location = @client.get_bucket_location(bucket: @bucket_name).location_constraint
            "https://#{@bucket_name}.#{bucket_location}.amazonaws.com"
          end
        end
      end
    end
  end
end
