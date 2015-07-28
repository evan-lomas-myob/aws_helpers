require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'retrieve_desired_capacity'
require_relative 'update_desired_capacity'

module AwsHelpers

  module AutoScaling

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::AutoScaling::Config.new(options))
      end

      def retrieve_desired_capacity(auto_scaling_group_name)
        AwsHelpers::AutoScaling::RetrieveDesiredCapacity.new(config.aws_auto_scaling_client, auto_scaling_group_name).execute
      end

      def update_desired_capacity(auto_scaling_group_name, desired_capacity, timeout)
        AwsHelpers::AutoScaling::UpdateDesiredCapacity.new(config.aws_auto_scaling_client, config.aws_elastic_load_balancing_client, auto_scaling_group_name, desired_capacity, timeout).execute
      end

    end

  end

end

