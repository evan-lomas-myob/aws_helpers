require 'aws-sdk-core'
require_relative '../common/client'

module AwsHelpers

  module EC2

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(options)
      end

      def image_create(name, instance_id, additional_tags = [])
#        EC2::Image.new(aws_ec2_client).create(instance_id, name, additional_tags)
      end

      def images_delete(name, options = nil)
#        EC2::Image.new(aws_ec2_client).delete(name, options)
      end

      def images_delete_by_time(name, time)
#        EC2::Image.new(aws_ec2_client).delete_by_time(name, time)
      end

      def images_find_by_tags(tags)
#        EC2::Image.new(aws_ec2_client).find_by_tag(tags)
      end

      private

      def aws_ec2_client
        @aws_ec2_client ||= Aws::EC2::Client.new(@options)
      end

    end

  end

end

