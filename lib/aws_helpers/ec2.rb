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
require_relative 'actions/ec2/instances_find_by_tags'
require_relative 'actions/ec2/instances_find_by_ids'
require_relative 'actions/ec2/poll_instance_state'

include AwsHelpers::Actions::EC2

module AwsHelpers

  class EC2 < AwsHelpers::Client

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
    def image_create(instance_id, name, options= {})
      ImageCreate.new(config, instance_id, name, options).execute
    end

    # De-register an AMI image and its associated snapshots
    # @param image_id [String] the id of the AMI
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout ($stdout) override $stdout when logging output
    def image_delete(image_id, options={})
      ImageDelete.new(config, image_id, options).execute
    end

    # De-register AMI images older than now
    # @param name [String] The value of the Name tag for the image
    # @param [Hash] options Optional time elements to remove after.
    # @option options [Integer] :hours Hours to keep images
    # @option options [Integer] :days Days to keep images
    # @option options [Integer] :months Months to keep images
    # @option options [Integer] :years Years to keep images
    def images_delete(name, options = {})
      ImagesDelete.new(config, name, options).execute
    end

    # Delete images older than specified time
    # @param name [String] The value of the Name tag for the image
    # @param time [String] Oldest time string in EC2 instance tags to remove after
    def images_delete_by_time(name, time)
      ImagesDeleteByTime.new(config, name, time).execute
    end

    # Return a list of images that match a given list of tags
    # @param tags [Hash] a hash of tag names mapped to one or more tag values
    #
    #   ```
    #   { 'Tag1' => ['Value1', 'Value2'], 'Tag2' => 'Value2' }
    #   ```
    #
    # @return [Array] list of images matching the tags list
    def images_find_by_tags(tags)
      ImagesFindByTags.new(config, tags).execute
    end

    # Create a desired number of EC2 instances using a known AMI
    # @param image_id [String] Name of the AMI to use
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [String] :instance_type (t2.micro) override the type of instance to create
    # @option options [Integer] :min_count minimum number of instances to create
    # @option options [Integer] :max_count maximum number of instance to create
    # @option options [Boolean] :monitoring detailed monitoring enabled
    # @option options [String] :app_name (no-name-supplied) tag Name of the instance
    # @option options [String] :build_number (nil) build number associated with the instance
    # @option options [IO] :stdout ($stdout) override $stdout when logging output
    # @option options [Hash] :poll_exists override instance exists polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 8,
    #     :delay => 15 # seconds
    #   }
    #   ```
    # @option options [Hash] :poll_running override instance running polling
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
    # @option options [Hash{Symbol => Integer}] :poll_running Override instance stopped polling
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

    # Return a list of instances that match a given list of tags
    # @param tags [Hash] a hash of tag names mapped to one or more tag values
    #
    #   ```
    #   { 'Tag1' => ['Value1', 'Value2'], 'Tag2' => 'Value2' }
    #   ```
    #
    # @return [Array] list of instances matching the tags list
    def instances_find_by_tags(tags)
      InstancesFindByTags.new(config, tags).execute
    end

    # Return a list of instances that match a given list of tags
    # @param ids [Array] List of ids to filter Instances on
    # @return [Array] list of instances matching the tags list
    def instances_find_by_ids(ids)
      InstancesFindByIds.new(config, ids).execute
    end

    # Terminate an EC2 instance
    # @param instance_id [String] The ID of the EC2 instance
    def instance_terminate(instance_id)
      InstanceTerminate.new(config, instance_id).execute
    end

    # Polls a given instance until it is running and healthy
    # @param instance_id [String] Instance Unique ID
    # @option options [IO] :stdout ($stdout) Override $stdout when logging output
    # @option options [Hash] Override instance healthy polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :delay => 15 # seconds
    #     :max_attempts => 8,
    #   }
    #   ```
    def poll_instance_healthy(instance_id, options)
      PollInstanceHealthy.new(config, instance_id, options).execute
    end

    # Polls a given instance until it is stopped
    # @param instance_id [String] Instance Unique ID
    # @option options [IO] :stdout ($stdout) Override $stdout when logging output
    # @option options [Hash] Override instance healthy polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :delay => 15 # seconds
    #     :max_attempts => 8,
    #   }
    #   ```
    def poll_instance_stopped(instance_id, options)
      PollInstanceStopped.new(instance_id, options).execute
    end


    # Polls a given instance until it is stopped
    # @param instance_id [String] Instance Unique ID
    # @param state [String] Instance State to Poll for
    # @option options [IO] :stdout ($stdout) Override $stdout when logging output
    # @option options [Hash] Override instance healthy polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :delay => 15 # seconds
    #     :max_attempts => 8,
    #   }
    #   ```
    def poll_instance_state(instance_id, state, options)
      PollInstanceState.new(instance_id, state, options).execute
    end

    # Returns the decrypted Windows administrator password for a given instance.
    # @param instance_id [String] Instance Unique ID
    # @param pem_path [String] Path to PEM-encoded private key file
    # @option options [IO] :stdout ($stdout) Override $stdout when logging output
    # @option options [Hash] Override instance polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :delay => 10 # seconds
    #     :max_attempts => 6,
    #   }
    #   ```
    def get_windows_password(instance_id, pem_path, options)
      GetWindowsPassword.new(config, instance_id, pem_path, options).get_password
    end

  end

end


