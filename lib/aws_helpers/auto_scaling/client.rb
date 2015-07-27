require 'aws-sdk-core'
require_relative '../common/client.rb'
require_relative 'retrieve_desired_capacity.rb'
require_relative 'update_desired_capacity.rb'

module AwsHelpers

  module AutoScaling

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(options)
      end

      def retrieve_desired_capacity(auto_scaling_group_name)
        AwsHelpers::AutoScaling::RetrieveDesiredCapacity.new(aws_auto_scaling_client, auto_scaling_group_name).execute
      end

      def update_desired_capacity(auto_scaling_group_name, desired_capacity, timeout)
        AwsHelpers::AutoScaling::UpdateDesiredCapacity.new(aws_auto_scaling_client, aws_elastic_load_balancing_client, auto_scaling_group_name, desired_capacity, timeout).execute
      end

      private

      def aws_auto_scaling_client
        @aws_auto_scaling_client = Aws::AutoScaling::Client.new(@options)
      end

      def aws_elastic_load_balancing_client
        @aws_elastic_load_balancing_client ||= Aws::ElasticLoadBalancing::Client.new(@options)
      end

    end

  end

end

