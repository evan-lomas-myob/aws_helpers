module AwsHelpers
  module Actions
    module EC2

      class EC2InstanceTag

        def initialize(config, instance_id, app_name = nil, build_number = nil, time = Time.now)
          @config = config
          @instance_id = instance_id
          @app_name = app_name || ''
          @build_number = build_number
          @time = time
        end

        def execute
          tags = build_tag(@app_name, @build_number, @time)
          client = @config.aws_ec2_client
          client.create_tags(
              resources: [@instance_id],
              tags: tags
          )
        end

        def build_tag(app_name, build_number, time)
          tags = []
          tags << {key: 'Name', value: app_name}
          tags << {key: 'Build Number', value: build_number} if build_number
          tags << {key: 'Date', value: time.to_s}
          tags
        end

      end

    end
  end
end

