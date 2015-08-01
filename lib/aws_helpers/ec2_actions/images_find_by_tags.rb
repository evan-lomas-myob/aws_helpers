module AwsHelpers

  module EC2Actions

    class ImagesFindByTags

      # Find EC2 instance that match given tag list
      # @param config [AwsHelpers::EC2::Config] Class to access Aws::EC2::Client object
      # @param tags [Array] List of tags to find matching EC2 instances for
      def initialize(config, tags)
        @config = config
        @tags = tags
      end

      def execute

      end

    end

  end

end