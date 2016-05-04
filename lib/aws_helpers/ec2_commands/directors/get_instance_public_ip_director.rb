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
          @commands = [
            AwsHelpers::EC2Commands::Commands::GetInstancePublicIpCommand.new(@config, request)
          ]
          puts "Director request: #{request.to_s}"
          execute_commands
        end
      end
    end
  end
end
