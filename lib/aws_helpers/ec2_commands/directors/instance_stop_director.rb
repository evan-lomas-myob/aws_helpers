require 'aws_helpers/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class InstanceStopDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def stop(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::InstanceStopCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
