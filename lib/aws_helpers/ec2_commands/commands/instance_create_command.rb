require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class InstanceCreateCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          puts "Actual user data: #{@request.user_data}"
          @request.instance_id = @client.run_instances(
            image_id: @request.image_id,
            min_count: 1,
            max_count: 1,
            user_data: Base64.encode64(@request.user_data || ''),
            instance_type: @request.instance_type || 't2.micro'
          ).instances[0].instance_id
        end
      end
    end
  end
end
