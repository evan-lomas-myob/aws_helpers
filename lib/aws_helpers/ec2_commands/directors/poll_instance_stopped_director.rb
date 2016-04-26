require 'aws_helpers/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class PollInstanceStoppedDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def execute(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::PollInstanceStoppedCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
