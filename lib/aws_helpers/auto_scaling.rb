require_relative 'client'
require_relative 'actions/auto_scaling/retrieve_desired_capacity'
require_relative 'actions/auto_scaling/update_desired_capacity'

include AwsHelpers::Actions::AutoScaling

module AwsHelpers

  class AutoScaling < AwsHelpers::Client

    # AutoScaling utilities for retrieving and updating
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    # @return [AwsHelpers::Config] A Config object with options initialized
    def initialize(options = {})
      super(options)
    end

    # @param auto_scaling_group_name [String] The group name of the Auto scaling client
    # @return [Integer] The desired capacity
    def retrieve_desired_capacity(auto_scaling_group_name:)
      RetrieveDesiredCapacity.new(config, auto_scaling_group_name).execute
    end

    # @param auto_scaling_group_name [String] The group name of the Auto scaling client
    # @param desired_capacity [Integer] The capacity level of the auto scaling group
    # @param timeout [Integer] The number of seconds to wait for the request to timeout
    def update_desired_capacity(auto_scaling_group_name:, desired_capacity:, timeout: 3600)
      UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, timeout).execute
    end

  end

end



