require_relative 'client'
require_relative 'actions/ec2/get_windows_password'
require_relative 'actions/ec2/image_create'
require_relative 'actions/ec2/images_delete'
require_relative 'actions/ec2/image_add_user'
require_relative 'actions/ec2/images_delete_by_time'
require_relative 'actions/ec2/images_find_by_tags'
require_relative 'actions/ec2/instance_create'
require_relative 'actions/ec2/instance_terminate'
require_relative 'actions/ec2/instance_stop'
require_relative 'actions/ec2/instance_start'
require_relative 'actions/ec2/instances_find_by_tags'
require_relative 'actions/ec2/instances_find_by_ids'
require_relative 'actions/ec2/poll_instance_state'
require_relative 'actions/ec2/get_vpc_id_by_name'
require_relative 'actions/ec2/get_security_group_id_by_name'
require 'aws_helpers/utilities/time'

Dir.glob(File.join(File.dirname(__FILE__), 'ec2_commands/**/*.rb'), &method(:require))

include AwsHelpers::EC2Commands::Directors
include AwsHelpers::EC2Commands::Requests
include AwsHelpers::Actions::EC2

module AwsHelpers
  class EC2 < AwsHelpers::Client
    # Utilities for EC2 creation, deletion and search of EC2 images
    #
    # @param options [Hash] Optional arguments to include when calling the AWS SDK. These arguments will
    #   affect all clients used by this helper. See the {http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html#initialize-instance_method AWS documentation}
    #   for a list of EC2-specific client options.
    # @example Initialise EC2 Client
    #    aws = AwsHelpers::EC2.new
    # @return [AwsHelpers::EC2]
    #
    def initialize(options = {})
      super(options)
    end

    # Create an AMI using an existing instance
    #
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
    # @example Create an Image
    #   AwsHelpers::EC2.new.image_create('i-12345678','New Image Name')
    #
    # @return [String] the image id
    #
    def image_create(instance_id, name, options = {})
      request = ImageCreateRequest.new
      request.instance_id = instance_id
      request.image_name = name
      request.tags = options[:tags] if options[:tags]
      request.instance_polling = options[:instance_polling] if options[:instance_polling]
      ImageCreateDirector.new(config).create(request)
      request.image_id
    end

    # De-register an AMI image and its associated snapshots
    #
    # @param image_id [String] the id of the AMI
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout ($stdout) override $stdout when logging output
    #
    # @example De-register an Image
    #   AwsHelpers::EC2.new.image_delete('ami-12345678')
    #
    # @return [Seahorse::Client::Response] An empty response
    #
    def image_delete(image_id)
      request = ImageDeleteRequest.new
      request.image_id = image_id
      ImageDeleteDirector.new(config).delete(request)
    end

    # Share an AMI with a User ID
    #
    # @param image_id [String] the id of the AMI
    # @param user_id [String] the id of the User to share the image with
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout ($stdout) override $stdout when logging output
    #
    # @example Add remote user id launch permission
    #   AwsHelpers::EC2.new.image_add_user('ami-12345678','123456789012')
    #
    # @return [Seahorse::Client::Response] An empty response
    #
    def image_add_user(image_id, user_id)
      request = ImageAddUserRequest.new
      request.image_id = image_id
      request.user_id = user_id
      ImageAddUserDirector.new(config).add(request)
    end

    def images_delete_before_time(name, options = {})
      time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(options)
      request = ImagesDeleteBeforeTimeRequest.new(image_name: name, time: time)
      ImagesDeleteBeforeTimeDirector.new(config).add(request)
    end

    def get_image_ids(name, options = {})
      request = GetImageIdsRequest.new
      request.image_name = name
      if options[:older_than].is_a? Hash
        request.older_than = AwsHelpers::Utilities::OlderThanTimeBuilder.new.build(options)
      elsif options[:older_than].is_a? Time
        request.older_than = options[:older_than]
      end
      request.with_tags = options[:with_tags] if options[:with_tags]
      GetImageIdsDirector.new(config).get(request)
    end

    # De-register AMI images older than range specified
    #
    # @param name [String] The value of the Name tag for the image
    # @param [Hash] options Optional time elements to remove after.
    # @option options [Integer] :hours Hours to keep images
    # @option options [Integer] :days Days to keep images
    # @option options [Integer] :months Months to keep images
    # @option options [Integer] :years Years to keep images
    #
    # @example Delete an image older than 1 day
    #   AwsHelpers::EC2.new.images_delete('Test Image Name',{days: 1})
    #
    # @return [Seahorse::Client::Response] An empty response
    #
    def images_delete(name, options = {})
      #TODO: Pass polling options
      ImagesDelete.new(config, name, options).execute
    end

    # De-register AMI images older than specified time
    #
    # @param name [String] The value of the Name tag for the image
    # @param time [String] Oldest time string in EC2 instance tags to remove after
    # @param [Hash] options Optional elements
    # @option options [IO] :stdout ($stdout) override $stdout when logging output
    # @option options [Hash] :poll_deleted override instance deleted polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 4,
    #   }
    #   ```
    # @example Remove AMI's older than 1 hour
    #  AwsHelpers::EC2.new.images_delete_by_time('Test Image Name',Time.now-3600)
    #
    # @return [Seahorse::Client::Response] An empty response
    #
    def images_delete_by_time(name, time, options = {})
      #TODO: Pass polling options
      ImagesDeleteByTime.new(config, name, time, options).execute
    end

    # Return a list of images that match a given list of tags
    #
    # @param tags [Hash] a hash of tag names mapped to one or more tag values
    #
    #   ```
    #   { 'Tag1' => ['Value1', 'Value2'], 'Tag2' => 'Value2' }
    #   ```
    # @example Return a list of images with matching tags
    #  AwsHelpers::EC2.new.images_find_by_tags(Name: 'Name Tag Value')
    #
    # @return [Array<<struct Aws::EC2::Types::Image>] list of images matching the tags list
    def images_find_by_tags(tags)
      ImagesFindByTags.new(config, tags).execute
    end

    # Create a desired number of EC2 instances using a known AMI
    #
    # @param image_id [String] Name of the AMI to use
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [String] :instance_type (t2.micro) override the type of instance to create
    # @option options [Integer] :min_count (1) minimum number of instances to create
    # @option options [Integer] :max_count (1) maximum number of instance to create
    # @option options [Boolean] :monitoring (false) detailed monitoring enabled
    # @option options [String] :app_name (no-name-supplied) tag Name of the instance
    # @option options [String] :build_number (nil) build number associated with the instance
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
    # @example Create a basic EC2 image with defaults
    #   AwsHelpers::EC2.new.instance_create('ami-12345678')
    #
    # @return [String] Instance ID
    #
    def instance_create(image_id, options = {})
      request = InstanceCreateRequest.new
      request.image_id = image_id
      request.instance_polling = options[:instance_polling] if options[:instance_polling]
      request.user_data = options[:user_data]
      request.tags = options[:tags] || [{ key: 'Name', value: 'no-name-supplied' }]
      InstanceCreateDirector.new(config).create(request)
      request.instance_id
    end

    # Start an existing EC2 instance
    #
    # @param instance_id [String] The ID of the EC2 instance
    # @option :instance_polling [Hash{Symbol => Integer}] Override instance running polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 8,
    #     :delay => 15 # seconds
    #   }
    #   ```
    #
    # @example Start the instance with known instance id
    #   AwsHelpers::EC2.new.instance_start('i-12345678')
    #
    # @return [nil]
    #
    def instance_start(instance_id, options = {})
      request = InstanceStartRequest.new
      request.instance_id = instance_id
      request.instance_polling = options[:instance_polling] if options[:instance_polling]
      InstanceStartDirector.new(config).start(request)
    end

    # Stop an EC2 instance
    # @param instance_id [String] The ID of the EC2 instance
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
    #
    # @example Stop the instance with known instance id
    #   AwsHelpers::EC2.new.instance_stop('i-12345678')
    #
    # @return [nil]
    #
    def instance_stop(instance_id, options = {})
      request = InstanceStopRequest.new
      request.instance_id = instance_id
      request.instance_polling = options[:instance_polling] if options[:instance_polling]
      InstanceStopDirector.new(config).stop(request)
    end

    # Return a list of instances that match a given list of tags
    #
    # @param tags [Hash] a hash of tag names mapped to one or more tag values
    #
    #   ```
    #   { 'Tag1' => ['Value1', 'Value2'], 'Tag2' => 'Value2' }
    #   ```
    #
    # @example Get a list of instance with matching tags
    #   AwsHelpers::EC2.new.instances_find_by_tags(Name: 'InstanceName', Environment: 'EnvName')
    #
    # @return [Array<<struct Aws::EC2::Types::Instance>] list of instances matching the tags list
    #
    def instances_find_by_tags(tags)
      InstancesFindByTags.new(config, tags).execute
    end

    # Return a list of running instance with given id
    #
    # @param ids [Array] List of ids to filter Instances on
    #
    # @example Get a list of matching instances
    #   AwsHelpers::EC2.new.instances_find_by_ids(['i-12345678','i-90123456'])
    #
    # @return [Array<<struct Aws::EC2::Types::Instance>] list of instances matching the tags list
    #
    def instances_find_by_ids(ids)
      InstancesFindByIds.new(config, ids).execute
    end

    # Terminate an EC2 instance
    #
    # @param instance_id [String] The ID of the EC2 instance
    #
    # @example Terminate this instance
    #   AwsHelpers::EC2.new.instance_terminate('i-12345678')
    #
    # @return [struct Aws::EC2::Types::TerminateInstancesResult]
    #

    def instance_terminate(instance_id)
      request = InstanceTerminateRequest.new
      request.instance_id = instance_id
      InstanceTerminateDirector.new(config).terminate(request)
    end

    # Polls a given instance until it is running and healthy
    #
    # @param instance_id [String] Instance Unique ID
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
    #
    # @example Poll instance health
    #   AwsHelpers::EC2.new.poll_instance_healthy('i-12345678')
    #
    # @return [nil]
    #

    def poll_instance_healthy(instance_id, options = {})
      request = PollInstanceHealthyRequest.new
      request.instance_id = instance_id
      request.instance_polling = options[:instance_polling] if options[:instance_polling]
      PollInstanceHealthyDirector.new(config).execute(request)
    end

    # Polls a given instance until it is stopped
    #
    # @param instance_id [String] Instance Unique ID
    # @option options[:instance_polling] [Hash] Override instance healthy polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :delay => 15 # seconds
    #     :max_attempts => 8,
    #   }
    #   ```
    #
    # @example Poll instance health
    #   AwsHelpers::EC2.new.poll_instance_stopped('i-12345678')
    #
    # @return [nil]
    #
    def poll_instance_stopped(instance_id, options = {})
      request = PollInstanceStoppedRequest.new
      request.instance_id = instance_id
      request.instance_polling = options[:instance_polling] if options[:instance_polling]
      PollInstanceStoppedDirector.new(config).execute(request)
    end

    # Polls a given instance until it is stopped
    # @param instance_id [String] Instance Unique ID
    # @param state [String] Instance State to Poll for
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
    #
    # @example Poll instance health
    #   AwsHelpers::EC2.new.poll_instance_state('i-12345678','running')
    #
    # @return [nil]
    #

    def poll_instance_state(instance_id, state, options = {})
      PollInstanceState.new(config, instance_id, state, options).execute
    end

    def get_instance_public_ip(instance_id)
      request = GetInstancePublicIpRequest.new
      request.instance_id = instance_id
      GetInstancePublicIpDirector.new(config).get(request)
      request.instance_public_ip
    end

    # Returns the decrypted Windows administrator password for a given instance.
    #
    # @example Get the decrypted Windows password
    #   AwsHelpers::EC2.new.get_windows_password('i-12345678', '~/.ssh/secret.pem')
    # @param instance_id [String] Instance Unique ID
    # @param pem_path [String] Path to PEM-encoded private key file
    # @option options[:instance_polling] [Hash] Override instance polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :delay => 10 # seconds
    #     :max_attempts => 6,
    #   }
    #   ```
    def get_windows_password(instance_id, pem_path, options = {})
      request = GetWindowsPasswordRequest.new
      request.instance_id = instance_id
      request.pem_path = pem_path
      request.instance_polling = options[:instance_polling] if options[:instance_polling]
      GetWindowsPasswordDirector.new(config).get(request)
    end

    # Returns the VPC ID for a given VPC Name.
    #
    # @param vpc_name [String] VPC Unique Name Tag
    # @example Get the VPC ID
    #   AwsHelpers::EC2.new.get_vpc_id_by_name('MyVPC')
    def get_vpc_id_by_name(vpc_name)
      request = GetVpcIdRequest.new
      request.vpc_name = vpc_name
      GetVpcIdDirector.new(config).get(request)
    end

    # Returns the Group ID for a given Security Group Name.
    #
    # @example Get the Security Group ID
    #   AwsHelpers::EC2.new.get_group_id_by_name('MySecurityGroup')
    # @param security_group_name [String] Security Group Name to Find
    def get_group_id_by_name(security_group_name)
      request = GetSecurityGroupIdRequest.new
      request.security_group_name = security_group_name
      GetSecurityGroupIdDirector.new(config).get(request)
    end
  end
end
