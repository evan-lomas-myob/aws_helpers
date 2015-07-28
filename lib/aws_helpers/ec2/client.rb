require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'image'

module AwsHelpers

  module EC2

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::EC2::Config.new(options))
      end

      def image_create(name, instance_id, additional_tags = [])
        AwsHelpers::EC2::Image.new(config.aws_ec2_client).create(instance_id, name, additional_tags)
      end

      def images_delete(name, options = nil)
        AwsHelpers::EC2::Image.new(config.aws_ec2_client).delete(name, options)
      end

      def images_delete_by_time(name, time)
        AwsHelpers::EC2::Image.new(config.aws_ec2_client).delete_by_time(name, time)
      end

      def images_find_by_tags(tags)
        AwsHelpers::EC2::Image.new(config.aws_ec2_client).find_by_tag(tags)
      end

    end

  end

end

