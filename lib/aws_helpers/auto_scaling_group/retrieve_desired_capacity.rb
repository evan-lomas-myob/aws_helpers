require 'aws-sdk-core'

module AwsHelpers
  module AutoScalingGroup

    class RetrieveDesiredCapacity

      def initialize(auto_scaling_group_name, client = Aws::AutoScaling::Client.new)
        @auto_scaling_group_name = auto_scaling_group_name
        @client = client
      end

      def execute
        auto_scaling_groups = @client.describe_auto_scaling_groups(:auto_scaling_group_names => [@auto_scaling_group_name])[:auto_scaling_groups]
        auto_scaling_groups.detect { |auto_scaling_group| auto_scaling_group[:auto_scaling_group_name] == @auto_scaling_group_name }[:desired_capacity]
      end

    end

  end
end
