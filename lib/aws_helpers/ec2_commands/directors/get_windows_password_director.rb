require 'aws_helpers/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class GetWindowsPasswordDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def get(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::GetWindowsPasswordCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
