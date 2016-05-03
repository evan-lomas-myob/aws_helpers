require 'aws_helpers/commands/command'

module AwsHelpers
  module Commands
    module S3
      class TemplateUrlCommand < AwsHelpers::Commands::Command
        def initialize(config, request)
          super(request)
          @client = config.aws_s3_client
        end

        def execute
          stack_name = request.stack_name
          bucket_name = request.bucket_name
          return unless stack_name && bucket_name

          bucket_location = @client.get_bucket_location(bucket: bucket_name).location_constraint
          request.template_url = "https://s3-#{bucket_location}.amazonaws.com/#{bucket_name}/#{stack_name}"
        end
      end
    end
  end
end
