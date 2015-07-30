require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'poll_healthy_instances'

module AwsHelpers

  module ElasticLoadBalancing

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::ElasticLoadBalancing::Config.new(options))
      end

      def poll_healthy_instances(load_balancer_name, required_instances, timeout)
        AwsHelpers::ElasticLoadBalancing::PollHealthyInstances.new(config, load_balancer_name, required_instances, timeout).execute
      end

    end

  end

end

