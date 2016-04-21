require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class GetVpcIdCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          response = @client.describe_vpcs(
            filters: [
              { name: 'tag:Name', values: [@request.vpc_name] }
            ])
          @request.vpc_id = response.vpcs.first.vpc_id unless response.vpcs.empty?
        end
      end
    end
  end
end
