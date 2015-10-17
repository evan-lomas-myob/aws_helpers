require_relative 'client'
require_relative 'actions/ec2/get_windows_password'
require_relative 'actions/ec2/image_create'
require_relative 'actions/ec2/images_delete'
require_relative 'actions/ec2/images_delete_by_time'
require_relative 'actions/ec2/images_find_by_tags'
require_relative 'actions/ec2/instance_create'
require_relative 'actions/ec2/instance_terminate'
require_relative 'actions/ec2/instance_stop'
require_relative 'actions/ec2/instance_start'
require_relative 'actions/ec2/instance_find_by_tag_value'

include AwsHelpers::Actions::EC2

module AwsHelpers

  class EC2 < AwsHelpers::Client

    # Utilities for EC2 creation, deletion and search of Ec2 images
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(options)
    end

    # Create an AMI using an existing image that is either running or stopped
    # @param instance_id [String] ID of the EC2 Instance
    # @param name [String] Name to assign to the AMI
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [Array] :additional_tags
    #
    #   ```
    #   [
    #     { key: 'Tag Key', value: 'Tag Value' }
    #   ]
    #   ```
    # @option options [Time] :now Override the current time
    # @option options [IO] :stdout ($stdout) Override $stdout when logging output
    def image_create(instance_id, name, options= {})
      ImageCreate.new(config, instance_id, name, options).execute
    end

    # De-register AMI images older than now
    # @param image_id [String] The ID of the AMI
    # @param [Hash] options Optional time elements to remove after.
    # @option options [Integer] :hours Hours to keep images
    # @option options [Integer] :days Days to keep images
    # @option options [Integer] :months Months to keep images
    # @option options [Integer] :years Years to keep images
    def images_delete(image_id, options = {})
      ImagesDelete.new(config, image_id, options).execute
    end

    # Delete images older than specified time
    # @param image_id [String] The ID of the AMI
    # @param time [String] Oldest time string in EC2 instance tags to remove after
    def images_delete_by_time(image_id, time)
      ImagesDeleteByTime.new(config, image_id, time).execute
    end

    # Return a list of images that match a given list of tags
    # @param tags [Array] List of tags to filter AMI's on
    # @return [Array] list of images matching the tags list
    def images_find_by_tags(tags)
      ImagesFindByTags.new(config, tags).execute
    end

    # Create a desired number of EC2 instances using a known AMI
    # @param image_id [String] Name of the AMI to use
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [String] :instance_type (t2.micro) Override the type of instance to create
    # @option options [Integer] :min_count Minimum number of instances to create
    # @option options [Integer] :max_count Maximum number of instance to create
    # @option options [Boolean] :monitoring Is monitoring required or not
    # @option options [String] :app_name (no-name-supplied) Name for the instance
    # @option options [String] :build_number (nil) Build Number associated with the instance
    # @option options [IO] :stdout ($stdout) Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :poll_exists Override instance exists polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 8,
    #     :delay => 15 # seconds
    #   }
    #   ```
    # @option options [Hash{Symbol => Integer}] :poll_running Override instance running polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 8,
    #     :delay => 15 # seconds
    #   }
    #   ```
    # @return [String] Instance ID
    def instance_create(image_id, options)
      InstanceCreate.new(config, image_id, options).execute
    end

    # Start an EC2 instance
    # @param instance_id [String] The ID of the EC2 instance
    # @option options [IO] :stdout ($stdout) Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :poll_running Override instance running polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 8,
    #     :delay => 15 # seconds
    #   }
    #   ```
    def instance_start(instance_id, options)
      InstanceStart.new(config, instance_id, options).execute
    end

    # Stop an EC2 instance
    # @param instance_id [String] The ID of the EC2 instance
    # @option options [IO] :stdout ($stdout) Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :poll_stopped Override instance stopped polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 8,
    #     :delay => 15 # seconds
    #   }
    #   ```
    def instance_stop(instance_id, options)
      InstanceStop.new(config, instance_id, options).execute
    end

    # Terminate an EC2 instance
    # @param instance_id [String] The ID of the EC2 instance
    def instance_terminate(instance_id)
      InstanceTerminate.new(config, instance_id).execute
    end

    # Return a list of instances that match a given list of tags
    # @param tag_values [Array] List of tags to filter Instances on
    # @return [Aws::EC2::Types::DescribeInstancesResult] list of Aws::EC2::Types::Reservation types
    def instance_find_by_tag_value(tag_values)
      InstanceFindByTagValue.new(config, tag_values).execute
    end

    # Polls a given instance until it is running and healthy
    # @param instance_id [String] Instance Unique ID
    def poll_instance_healthy(instance_id)
      PollInstanceHealthy.new(instance_id).execute
    end

    # Returns the decrypted Windows administrator password for a given instance.
    # @param instance_id [String] Instance Unique ID
    # @param pem_path [String] Path to PEM-encoded private key file
    def get_windows_password(instance_id, pem_path)
      GetWindowsPassword.new(config, instance_id, pem_path).get_password
    end

  end

end


