module AwsHelpers
  module Actions
    module EC2
      class ImagesFindByTags
        def initialize(config, tags)
          @client = config.aws_ec2_client
          @tags = tags
        end

        def execute
          @client.describe_images(filters: tag_filters).images
        end

        private

        def tag_filters
          case @tags
          when Array
            warn 'Deprecation warning: AWS::EC2#images_find_by_tags now accepts a hash instead of an array'
            @tags.map { |tag| { name: "tag:#{tag[:name]}", values: [tag[:value]] } }
          when Hash
            @tags.map { |name, *values| { name: "tag:#{name}", values: values.flatten } }
          else
            raise ArgumentError.new('Could not parse tags')
          end
        end
      end
    end
  end
end
