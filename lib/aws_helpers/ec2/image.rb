module AwsHelpers
  module EC2

    class Image

      def initialize(aws_ec2_client)

      end

      def create(name, instance_id, additional_tags = [])

      end

      def delete(name, options)

      end

      def delete_by_time(name, time)

      end

      def find_by_tag(tags)

      end

    end
  end
end