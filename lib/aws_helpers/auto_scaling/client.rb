require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'retrieve_desired_capacity'
require_relative 'update_desired_capacity'

module AwsHelpers

  module AutoScaling

    class Client < AwsHelpers::Common::Client

      # Interface for AWS AutoScaling to retrieve and update capacity settings
      # @param options [Hash] Optional arguments to pass to the AWS Ruby SDK

      def initialize(options = {})
        super(AwsHelpers::AutoScaling::Config.new(options))
      end

      # @param auto_scaling_group_name [String] The group name of the Auto scaling client
      # @return [AwsHelpers::AutoScaling::RetrieveDesiredCapacity]

      def retrieve_desired_capacity(auto_scaling_group_name:)
        AwsHelpers::AutoScaling::RetrieveDesiredCapacity.new(config, auto_scaling_group_name).execute
      end

      # @param auto_scaling_group_name [String] The group name of the Auto scaling client
      # @param desired_capacity [Integer] The capacity level of the auto scaling group
      # @param timeout [Integer] The number of seconds to wait for the request to timeout
      # @return [AwsHelpers::AutoScaling::UpdateDesiredCapacity]

      def update_desired_capacity(auto_scaling_group_name:, desired_capacity:, timeout: 3600)
        AwsHelpers::AutoScaling::UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, timeout).execute
      end

    end

    # Client.new.update_desired_capacity(auto_scaling_group_name: 'blah')
    # h = {auto_scaling_group_name: 'blah'}
    # Client.new.update_desired_capacity(h)
    # Client.new.update_desired_capacity('blah')

  end


end

