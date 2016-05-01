require 'aws_helpers/commands/s3/bucket_exists_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module Directors
    module S3
      class BucketExistsDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def exists?(request)
          @commands = [
              AwsHelpers::Commands::S3::BucketExistsCommand.new(@config, request)
          ]
          execute_commands
          request.bucket_exists
        end

      end
    end
  end
end