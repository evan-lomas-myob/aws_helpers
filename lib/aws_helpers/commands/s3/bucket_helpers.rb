module AwsHelpers
  module Commands
    module S3
      module BucketHelpers
        def check_bucket_exists(aws_s3_client, name)
          return false unless name

          buckets = aws_s3_client.list_buckets.buckets
          buckets.select { |bucket| bucket.name == name }.any?
        end
      end
    end
  end
end
