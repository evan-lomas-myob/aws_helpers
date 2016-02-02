require_relative 'client'
require_relative 'actions/nat/gateway_create'
require_relative 'actions/nat/gateway_delete'

include AwsHelpers::Actions::NAT

module AwsHelpers

  class NAT < AwsHelpers::Client

    # Utilities for EC2 creation, deletion and search of Ec2 images
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(options)
    end

    # Create an AMI using an existing instance
    # @param instance_id [String] Id of the EC2 Instance
    # @param name [String] Name to assign to the AMI
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [Array] :additional_tags additional tags to put into the image
    #
    #   ```
    #   [
    #     { key: 'Tag Key', value: 'Tag Value' }
    #   ]
    #   ```
    # @option options [Time] :now override the current time
    # @option options [IO] :stdout ($stdout) override $stdout when logging output
    # @option options [Hash] :poll_image_available override image available polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 20,
    #     :delay => 30 # seconds
    #   }
    #   ```
    # @return [String] the image id
    def gateway_create(subnet_id, allocation_id)
      GatewayCreate.new(config, subnet_id, allocation_id).execute
    end

    # De-register an AMI image and its associated snapshots
    # @param image_id [String] the id of the AMI
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout ($stdout) override $stdout when logging output
    def gateway_delete(gateway_id)
      GatewayDelete.new(config, gateway_id).execute
    end
  end

end


