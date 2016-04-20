require 'aws_helpers/nat_commands/commands/gateway_delete_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module NATCommands
    module Directors
      class GatewayDeleteDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def delete(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::GatewayCreateCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
