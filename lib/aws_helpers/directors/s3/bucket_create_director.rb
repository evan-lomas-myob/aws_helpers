require 'aws_helpers/commands/s3/bucket_exists_command'
require 'aws_helpers/commands/s3/bucket_create_command'
require 'aws_helpers/commands/s3/poll_bucket_exists_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module Directors
    module S3
      class BucketCreateDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @commands = [
              AwsHelpers::Commands::S3::BucketExistsCommand.new(@config, request),
              AwsHelpers::Commands::S3::BucketCreateCommand.new(@config, request),
              AwsHelpers::Commands::S3::PollBucketExistsCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end