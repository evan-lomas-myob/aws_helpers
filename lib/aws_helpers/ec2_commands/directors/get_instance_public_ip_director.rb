require 'aws_helpers/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class GetInstancePublicIpDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def get(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::GetInstancePublicIpCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
