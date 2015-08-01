module AwsHelpers

  module EC2Actions

    class ImagesDelete

      # Delete AWS EC2 instance

      # @param config [AwsHelpers::EC2::Config] Class to access Aws::EC2::Client object
      # @param name [String] Name given to the AWS EC2 instance
      # @param days [Integer] Minus number of days to delete images from
      # @param months [Integer] Minus number of months to delete images from
      # @param years [Integer] Minus number of years to delete images from
      def initialize(config, name, days, months, years)

        @config = config
        @name = name
        @days = days
        @months = months
        @years = years

      end

      def execute

      end

    end

  end

end