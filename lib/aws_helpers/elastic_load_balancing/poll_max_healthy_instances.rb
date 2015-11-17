require 'timeout'
require_relative 'instance_state'

module AwsHelpers
  module ElasticLoadBalancing
    class PollMaxHealthyInstances
      def initialize(elastic_load_balancing_client, load_balancer_name, required_instances, timeout)
        @elastic_load_balancing_client = elastic_load_balancing_client
        @load_balancer_name = load_balancer_name
        @required_instances = required_instances
        @timeout = timeout
      end

      def execute
        puts "Polling #{@load_balancer_name} for maximum #{@required_instances} healthy instances"
        Timeout::timeout(@timeout) {
          loop do
            response = @elastic_load_balancing_client.describe_instance_health(load_balancer_name: @load_balancer_name)
            instance_states = response[:instance_states]
            in_service_count = instance_states.select{|instance_state| instance_state[:state] == IN_SERVICE }.count
            out_of_service = instance_states.count - in_service_count

            puts "In Service: #{in_service_count} Out of Service: #{out_of_service}"

            break if in_service_count <= @required_instances
            sleep 15
          end
        }

      end

    end
  end
end
