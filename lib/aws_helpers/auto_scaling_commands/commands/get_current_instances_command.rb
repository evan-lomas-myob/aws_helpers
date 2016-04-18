require 'aws_helpers/auto_scaling_commands/commands/command'

module AwsHelpers
  module AutoScalingCommands
    module Commands
      class GetCurrentInstancesCommand < AwsHelpers::AutoScalingCommands::Commands::Command
        def initialize(config, request)
          @client = config.aws_auto_scaling_client
          @request = request
        end

        def execute
          response = @client.describe_auto_scaling_groups(auto_scaling_group_names: [@request.auto_scaling_group_name])
          group = response.auto_scaling_groups.find do |auto_scaling_group|
            auto_scaling_group.auto_scaling_group_name == @request.auto_scaling_group_name
          end
          @request.current_instances = group.instances.map { |i| i.instance_id } unless response.auto_scaling_groups.empty?
        end
      end
    end
  end
end
