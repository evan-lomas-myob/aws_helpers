require 'aws-sdk-core'

module AwsHelpers
  module Actions
    module EC2
      class GetVpcIdByName
        def initialize(config, vpc_name, options = {})
          @client = config.aws_ec2_client
          @vpc_name = vpc_name
          @stdout = options[:stdout] ||= $stdout
        end

        def id
          response = @client.describe_vpcs(
            filters: [
              { name: 'tag:Name', values: [@vpc_name] }
            ])
          response.vpcs.first.vpc_id unless response.vpcs.empty?
        end
      end
    end
  end
end
