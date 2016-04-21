require 'aws_helpers/elb_commands/commands/poll_in_service_instances_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module ELBCommands
    module Directors
      class PollInServiceInstancesDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def execute(request)
          @request = request
          @commands = [
            AwsHelpers::ELBCommands::Commands::PollInServiceInstancesCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
