require 'aws-sdk-core'
require_relative 'client'
require_relative 'auto_scaling_actions/retrieve_desired_capacity'
require_relative 'auto_scaling_actions/update_desired_capacity'

module AwsHelpers

  class AutoScaling < AwsHelpers::Client

      def initialize(options = {})
        super(options)
      end

      # @param auto_scaling_group_name [String] The group name of the Auto scaling client
      # @return [Integer]
      def retrieve_desired_capacity(auto_scaling_group_name:)
        AutoScalingActions::RetrieveDesiredCapacity.new(config, auto_scaling_group_name).execute
      end

      # @param auto_scaling_group_name [String] The group name of the Auto scaling client
      # @param desired_capacity [Integer] The capacity level of the auto scaling group
      # @param timeout [Integer] The number of seconds to wait for the request to timeout
      def update_desired_capacity(auto_scaling_group_name:, desired_capacity:, timeout: 3600)
        AutoScalingActions::UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, timeout).execute
      end

  end

end



