require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class GetRunningInstanceIdsCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          response = @client.describe_instances(instance_ids: @request.instance_ids).reservations.map { |r| r.instances }.flatten
          @request.running_instance_ids = response.select { |instance| instance.state.name == 'running' }.map(&:instance_id)
        end
      end
    end
  end
end
