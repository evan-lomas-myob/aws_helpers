require 'aws-sdk-core'
require_relative '../common/client'

module AwsHelpers

  module ElasticLoadBalancing

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(options)
      end

      def poll_healthy_instances(load_balancer_name, required_instances, timeout)
        # ElasticLoadBalancing::PollHealthyInstances.new(aws_elastic_load_balancing_client, load_balancer_name, required_instances, timeout).execute
      end

      private

      def aws_elastic_load_balancing_client
        @aws_elb_client ||= Aws::ElasticLoadBalancing::Client.new(@options)
      end

    end

  end

end

