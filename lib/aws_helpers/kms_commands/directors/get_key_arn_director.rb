# require 'aws_helpers/kms_commands/commands/get_key_arn_command'
require 'aws_helpers/kms_commands/commands/command_runner'

module AwsHelpers
  module KMSCommands
    module Directors
      class GetKeyArnDirector
        include AwsHelpers::KMSCommands::Commands::CommandRunner

        def initialize(config)
          @config = config
        end

        def get(request)
          @commands = [
            AwsHelpers::KMSCommands::Commands::GetKeyArnCommand.new(@config, request)
          ]
          execute_commands
          request.key_arn
        end
      end
    end
  end
end
