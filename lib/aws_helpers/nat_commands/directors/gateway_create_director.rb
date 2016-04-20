require 'aws_helpers/nat_commands/commands/gateway_create_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module NATCommands
    module Directors
      class GatewayCreateDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @request = request
          @commands = [
            AwsHelpers::NATCommands::Commands::GatewayCreateCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
