require_relative 'client'
require_relative 'actions/ec2/image_create'
require_relative 'actions/ec2/images_delete'
require_relative 'actions/ec2/images_delete_by_time'
require_relative 'actions/ec2/images_find_by_tags'

include AwsHelpers::Actions::EC2

module AwsHelpers

  class EC2 < AwsHelpers::Client

    # Utilities for EC2 creation, deletion and search of Ec2 images
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    # @return [AwsHelpers::Config] A Config object with options initialized
    def initialize(options = {})
      super(options)
    end

    # Create an AMI using an existing image that is either running or stopped
    # @param name [String] Name to assign to the AMI
    # @param instance_id [String] ID of the EC2 Instance
    # @param additional_tags [Array] Optional tags to include
    def image_create(name, instance_id, additional_tags= [])
      ImageCreate.new(config, name, instance_id, additional_tags).execute
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
    def images_find_by_tags(tags = [])
      ImagesFindByTags.new(config, tags).execute
    end

  end

end


