module AwsHelpers
  module ElasticBeanstalk
    class VersionFile

      def initialize(s3_client, iam_client, application, version, contents)
        @s3_client = s3_client
        @iam_client = iam_client
        @application = application
        @version = version
        @contents = contents
      end

      def upload_to_s3
        puts "Uploading #{file_name} to S3 bucket #{bucket} "
        @s3_client.put_object(
          bucket: bucket,
          key: file_name,
          body: @contents
        )
      end

      def version
        @version
      end

      def file_name
        @file_name ||= "#{@application}-#{@version}.aws.json"
      end

      def bucket
        @bucket ||= query_bucket_name
      end

      def query_bucket_name
        region = @iam_client.config.region
        account = @iam_client.list_users[:users].first[:arn][/::(.*):/, 1]
        "elasticbeanstalk-#{region}-#{account}"
      end

    end
  end
end