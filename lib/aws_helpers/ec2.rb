require_relative 'client'
require_relative 'actions/ec2/image_create'
require_relative 'actions/ec2/images_delete'
require_relative 'actions/ec2/images_delete_by_time'
require_relative 'actions/ec2/images_find_by_tag'

include AwsHelpers::Actions::EC2

module AwsHelpers

  class EC2 < AwsHelpers::Client

    # Utilities for EC2 creation, deletion and search
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    # @return [AwsHelpers::Config] A Config object with options initialized
    def initialize(options = {})
      super(options)
    end

    # @param name [String] Name given to the AWS EC2 instance
    # @param instance_id [String] Unique ID of the AWS instance
    # @param additional_tags [Array] Optional tags to include
    def image_create(name:, instance_id:, additional_tags: [])
      ImageCreate.new(config, name, instance_id, additional_tags).execute
    end

    # @param name [String] Name given to the AWS EC2 instance
    # @param days [Integer] Minus number of days to delete images from
    # @param months [Integer] Minus number of months to delete images from
    # @param years [Integer] Minus number of years to delete images from
    def images_delete(name:, days: nil, months: nil, years: nil)
      ImagesDelete.new(config, name, days, months, years).execute
    end

    # @param name [String] Name given to the AWS EC2 instance
    # @param time [String] Time stamp to remove matching EC2 instances
    def images_delete_by_time(name:, time:)
      ImagesDeleteByTime.new(config, name, time).execute
    end

    # @param [Hash] tag the filter
    # @options tag [String] :name The name of the tag in the image
    # @options tag [Array] :values An array of values to search for in image tags
    # @return [Array] list of images matching the tags list
    def images_find_by_tag(tag: {})
      ImagesFindByTag.new(config, tag).execute
    end

  end

end


