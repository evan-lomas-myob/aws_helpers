require_relative '../elastic_load_balancing/poll_healthy_instances'

module AwsHelpers
  module AutoScalingGroup

    class UpdateDesiredCapacity

      def initialize(auto_scaling_client, elastic_load_balancing_client,  auto_scaling_group_name, desired_capacity, timeout)
        @auto_scaling_client = auto_scaling_client
        @elastic_load_balancing_client = elastic_load_balancing_client
        @auto_scaling_group_name = auto_scaling_group_name
        @desired_capacity = desired_capacity
        @timeout = timeout
      end

      def execute
        puts "Setting #{@auto_scaling_group_name} desired capacity to #{@desired_capacity}"
        @auto_scaling_client.set_desired_capacity(
          :auto_scaling_group_name => @auto_scaling_group_name,
          :desired_capacity => @desired_capacity)
        auto_scaling_groups = @auto_scaling_client.describe_auto_scaling_groups(:auto_scaling_group_names => [@auto_scaling_group_name])[:auto_scaling_groups]
        load_balancer_names = auto_scaling_groups.detect { |auto_scaling_group| auto_scaling_group[:auto_scaling_group_name] == @auto_scaling_group_name }[:load_balancer_names]
        load_balancer_names.each { |load_balancer_name|
          ElasticLoadBalancing::PollHealthyInstances.new(@elastic_load_balancing_client, load_balancer_name, @desired_capacity, @timeout).execute
        }

      end

    end
  end
end