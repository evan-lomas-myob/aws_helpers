module AwsHelpers

  module EC2Actions

    class ImageCreate

      # Create AWS EC2 instance

      # @param config [AwsHelpers::EC2::Config] Class to access Aws::EC2::Client object
      # @param name [String] Name given to the AWS EC2 instance
      # @param instance_id [String] Unique ID of the AWS instance
      # @param additional_tags [Array] Optional tags to include
      def initialize(config, name, instance_id, additional_tags)
        @config = config
        @name = name
        @instance_id = instance_id
        @additional_tags = additional_tags
      end

      def execute

      end

    end

  end

end