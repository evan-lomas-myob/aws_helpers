require 'aws_helpers/ec2_commands/commands/instance_terminate_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class PollInstanceHealthyDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def execute(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::PollInstanceHealthyCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
