module AwsHelpers

  module EC2Actions

    class ImagesDeleteByTime
      # Delete AWS EC2 instance by matching time
      # @param config [AwsHelpers::EC2::Config] Class to access Aws::EC2::Client object
      # @param name [String] Name given to the AWS EC2 instance
      # @param time [String] Time stamp to remove matching EC2 instances
      def initialize(config, name, time)
        @config = config
        @name = name
        @time = time
      end

      def execute

      end

    end

  end

end