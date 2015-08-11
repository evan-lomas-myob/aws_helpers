require 'timeout'

module AwsHelpers
  module Actions
    module AutoScaling

      class PollHealthyInstances

        IN_SERVICE = 'InService'

        def initialize(std_out, config, auto_scaling_group_name, expected_number_instances, timeout)
          @std_out = std_out
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
          @expected_number_instances = expected_number_instances
          @timeout = timeout
        end

        def execute
          client = @config.aws_auto_scaling_client
          Timeout::timeout(@timeout) {
            while true
              response = client.describe_auto_scaling_groups(auto_scaling_group_names: [@auto_scaling_group_name])
              auto_scaling_group = response.auto_scaling_groups.find { |auto_scaling_group| auto_scaling_group.auto_scaling_group_name = @auto_scaling_group_name }
              instances = auto_scaling_group.instances
              in_service_count = instances.select { |instance| instance.lifecycle_state == IN_SERVICE }.count
              out_of_service_count = instances.count - in_service_count
              @std_out.puts("#{@auto_scaling_group_name} instances. In Service:#{in_service_count}, Out of Service:#{out_of_service_count}")
              break if in_service_count >= @expected_number_instances
            end
          }
        end

      end

    end
  end
end
