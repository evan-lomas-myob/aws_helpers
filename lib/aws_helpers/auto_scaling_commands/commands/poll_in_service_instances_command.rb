require 'aws_helpers/command'

module AwsHelpers
  module AutoScalingCommands
    module Commands
      class PollInServiceInstancesCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_auto_scaling_client
          @request = request
        end

        def execute
          # response = @client.describe_auto_scaling_groups(auto_scaling_group_names: [@request.auto_scaling_group_name])
          # group = response.auto_scaling_groups.find do |auto_scaling_group|
          #   auto_scaling_group.auto_scaling_group_name == @request.auto_scaling_group_name
          # end
          # @request.current_instances = group.instances.map { |i| i.instance_id } unless response.auto_scaling_groups.empty?
          poll(@request.instance_polling[:delay], @request.instance_polling[:max_attempts]) do
            response = @client.describe_auto_scaling_groups(auto_scaling_group_names: [@request.auto_scaling_group_name])
            auto_scaling_group = find_autoscaling_group(response)
            desired_capacity = auto_scaling_group.desired_capacity
            instances = auto_scaling_group.instances
            lifecycle_state_count = count_lifecycle_states(instances)
            lifecycle_state_output = create_lifecycle_state_output(lifecycle_state_count)
            output = "Auto Scaling Group=#{@auto_scaling_group_name}. Desired Capacity=#{desired_capacity}#{lifecycle_state_output}"
            std_out.puts(output)
            lifecycle_state_count['InService'] == desired_capacity
          end
        end

        private

        def find_autoscaling_group(response)
          response.auto_scaling_groups.find { |auto_scaling_group| auto_scaling_group.auto_scaling_group_name = @request.auto_scaling_group_name }
        end

        def count_lifecycle_states(instances)
          instances.each_with_object(Hash.new(0)) { |instance, hash| hash[instance.lifecycle_state] += 1 }
        end

        def create_lifecycle_state_output(lifecycle_state_count)
          lifecycle_state_count.sort.map { |state| ", #{state.join('=')}" }.join
        end
      end
    end
  end
end
