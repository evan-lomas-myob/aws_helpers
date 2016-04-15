require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module AutoScaling
      class PollInServiceInstances
        include AwsHelpers::Utilities::Polling

        IN_SERVICE = 'InService'.freeze

        def initialize(config, auto_scaling_group_name, options = {})
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 15
          @max_attempts = options[:max_attempts] || 20
        end

        def execute
          client = @config.aws_auto_scaling_client
          poll(@delay, @max_attempts) do
            response = client.describe_auto_scaling_groups(auto_scaling_group_names: [@auto_scaling_group_name])
            auto_scaling_group = find_autoscaling_group(response)
            desired_capacity = auto_scaling_group.desired_capacity
            instances = auto_scaling_group.instances
            lifecycle_state_count = count_lifecycle_states(instances)
            lifecycle_state_output = create_lifecycle_state_output(lifecycle_state_count)
            output = "Auto Scaling Group=#{@auto_scaling_group_name}. Desired Capacity=#{desired_capacity}#{lifecycle_state_output}"
            @stdout.puts(output)
            lifecycle_state_count[IN_SERVICE] == desired_capacity
          end
        end

        private

        def create_lifecycle_state_output(lifecycle_state_count)
          lifecycle_state_count.sort.map { |state| ", #{state.join('=')}" }.join
        end

        def find_autoscaling_group(response)
          response.auto_scaling_groups.find { |auto_scaling_group| auto_scaling_group.auto_scaling_group_name = @auto_scaling_group_name }
        end

        def count_lifecycle_states(instances)
          instances.each_with_object(Hash.new(0)) { |instance, hash| hash[instance.lifecycle_state] += 1 }
        end
      end
    end
  end
end
