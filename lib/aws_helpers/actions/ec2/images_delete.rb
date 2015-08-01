module AwsHelpers

  module EC2Actions

    class ImagesDelete

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