require 'aws_helpers/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class InstanceStartDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def start(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::InstanceStartCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
