require 'aws-sdk-core'

module AwsHelpers
  module Actions
    module AutoScaling

      class PollHealthyInstances

        IN_SERVICE = 'InService'

        def initialize(std_out, config, auto_scaling_group_name, delay, max_attempts)
          @std_out = std_out
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
          @delay = delay
          @max_attempts = max_attempts
          @timeout = delay * max_attempts
        end

        def execute
          client = @config.aws_auto_scaling_client
          attempts = 0
          while true
            response = client.describe_auto_scaling_groups(auto_scaling_group_names: [@auto_scaling_group_name])
            auto_scaling_group = find_autoscaling_group(response)
            desired_capacity = auto_scaling_group.desired_capacity
            instances = auto_scaling_group.instances
            lifecycle_state_count = count_lifecycle_states(instances)
            lifecycle_state_output = create_lifecycle_state_output(lifecycle_state_count)
            in_service_count = lifecycle_state_count[IN_SERVICE]
            @std_out.puts("#{@auto_scaling_group_name} instances. Desired Capacity=#{desired_capacity}, #{lifecycle_state_output}")
            break if in_service_count >= desired_capacity
            attempts = attempts + 1
            raise Aws::Waiters::Errors::TooManyAttemptsError.new(attempts) if attempts == @max_attempts
            sleep(@delay)
          end

        end

        def create_lifecycle_state_output(lifecycle_state_count)
          lifecycle_state_count.sort_by { |name| name }.map { |state| state.join('=') }.join(', ')
        end

        def find_autoscaling_group(response)
          response.auto_scaling_groups.find { |auto_scaling_group| auto_scaling_group.auto_scaling_group_name = @auto_scaling_group_name }
        end

        private

        def count_lifecycle_states(instances)
          instances.inject(Hash.new(0)) { |hash, instance| hash[instance.lifecycle_state] += 1; hash }
        end

      end

    end
  end
end
