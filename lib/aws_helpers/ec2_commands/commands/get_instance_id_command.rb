require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class GetInstanceIdCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          response = @client.describe_instances(
            filters: [
              { name: 'tag:Name', values: [@request.instance_name] }
            ])
          @request.instance_id = response.reservations.first.instances.first.instance_id unless response.reservations.empty?
        end
      end
    end
  end
end
