module AwsHelpers
  module Actions
    module EC2
      class EC2InstanceTag
        def initialize(config, instance_id, name_tag = nil, build_number = nil, time = Time.now)
          @config = config
          @instance_id = instance_id
          @name_tag = name_tag || 'no-name-supplied'
          @build_number = build_number
          @time = time
        end

        def execute
          tags = build_tag(@name_tag, @build_number, @time)
          client = @config.aws_ec2_client
          client.create_tags(
            resources: [@instance_id],
            tags: tags
          )
        end

        def build_tag(name_tag, build_number, time)
          tags = []
          tags << { key: 'Name', value: name_tag }
          tags << { key: 'Build Number', value: build_number } if build_number
          tags << { key: 'Date', value: time.to_s }
          tags
        end
      end
    end
  end
end
