module AwsHelpers
  module AutoScalingGroup

    class RetrieveDesiredCapacity

      def initialize(auto_scaling_client, auto_scaling_group_name)
        @auto_scaling_client = auto_scaling_client
        @auto_scaling_group_name = auto_scaling_group_name
      end

      def execute
        auto_scaling_groups = @auto_scaling_client.describe_auto_scaling_groups(:auto_scaling_group_names => [@auto_scaling_group_name])[:auto_scaling_groups]
        auto_scaling_groups.detect { |auto_scaling_group| auto_scaling_group[:auto_scaling_group_name] == @auto_scaling_group_name }[:desired_capacity]
      end

    end

  end
end
