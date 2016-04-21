require 'aws_helpers/command_runner'

module AwsHelpers
  module KMSCommands
    module Directors
      class GetKeyArnDirector
        include AwsHelpers::CommandRunner

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
