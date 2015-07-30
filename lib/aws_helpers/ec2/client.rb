require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'image_create'
require_relative 'images_delete'
require_relative 'images_delete_by_time'
require_relative 'images_find_by_tags'

module AwsHelpers

  module EC2

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::EC2::Config.new(options))
      end

      def image_create(name, instance_id, additional_tags = [])
        AwsHelpers::EC2::ImageCreate.new(config, name, instance_id, additional_tags).execute
      end

      def images_delete(name, options = nil)
        AwsHelpers::EC2::ImagesDelete.new(config, name, options).execute
      end

      def images_delete_by_time(name, time)
        AwsHelpers::EC2::ImagesDeleteByTime.new(config, name, time).execute
      end

      def images_find_by_tags(tags)
        AwsHelpers::EC2::ImagesFindByTags.new(config, tags).execute
      end

    end

  end

end
=begin

# Examples of defining AwsHelpers as Modules - not Clasess
# Using Class implementations becomes rigid - it can only be used in this way once initialized

class EC2Client
  include AwsHelpers::EC2::Client


end



class TopLevelClient
  include AwsHelpers::EC2::Client
  include AwsHelpers::S3::Client



end
=end



