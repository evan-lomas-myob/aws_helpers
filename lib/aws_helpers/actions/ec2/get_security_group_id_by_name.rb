require 'aws-sdk-core'

module AwsHelpers
  module Actions
    module EC2
      class GetSecurityGroupIdByName
        def initialize(config, security_group_name, options)
          @client = config.aws_ec2_client
          @security_group_name = security_group_name
          @stdout = options[:stdout] || $stdout
        end

        def id
          response = @client.describe_security_groups(
            filters:
              [
                { name: 'group-name', values: [@security_group_name] }
              ])
          response.security_groups.first.group_id unless response.security_groups.empty?
        end
      end
    end
  end
end
