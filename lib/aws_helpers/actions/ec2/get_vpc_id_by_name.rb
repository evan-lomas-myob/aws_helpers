require 'aws-sdk-core'
require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module EC2

      class GetVpcIdByName

        def initialize(config, vpc_name, options)
          @config = config
          @vpc_name = vpc_name
          @stdout = options[:stdout] || $stdout
        end

        def get_id
          client = @config ? @config.aws_ec2_client : Aws::EC2::Client.new()
          client.describe_vpcs(filters: [
              {name: 'tag:Name', values: [@vpc_name]}
          ]).vpcs.first.vpc_id
        end

      end

    end
  end
end