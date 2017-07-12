module AwsHelpers
  module Actions
    module Redshift
      class RedshiftInstanceTag
        def initialize(config, cluster_identifier, name_tag = nil, build_number = nil, time = Time.now)
          @config = config
          @cluster_identifier = cluster_identifier
          @name_tag = name_tag || 'no-name-supplied'
          @build_number = build_number
          @time = time
        end

        def execute
          tags = build_tag(@name_tag, @build_number, @time)
          client = @config.aws_redshift_client
          client.create_tags(
            resources: [@cluster_identifier],
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
