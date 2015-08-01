module AwsHelpers

  module EC2Actions

    class ImageCreate

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