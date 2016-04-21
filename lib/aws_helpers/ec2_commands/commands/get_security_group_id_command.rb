require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class GetSecurityGroupIdCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          response = @client.describe_security_groups(
            filters: [
              { name: 'tag:Name', values: [@request.security_group_name] }
            ])
          @request.security_group_id = response.security_groups.first.group_id unless response.security_groups.empty?
        end
      end
    end
  end
end
