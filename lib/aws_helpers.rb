require 'aws_helpers/version'
require_relative 'aws_helpers/cloud_formation/stack'
require_relative 'aws_helpers/elastic_beanstalk/version'
require_relative 'aws_helpers/rds/instance'
require_relative 'aws_helpers/ec2/image'

module AwsHelpers
  extend self

  class << self

    def stack_provision(stack_name, template, options = {})
      CloudFormation::Stack.new(stack_name, template, options).provision
    end

    def stack_s3_provision(stack_name, template, bucket_name, options = {}, bucket_encrypt = false)
      CloudFormation::Stack.new(stack_name, template, options.merge(bucket_name: bucket_name, bucket_encrypt: bucket_encrypt)).provision
    end

    def stack_outputs(stack_name)
      CloudFormation::Stack.outputs(stack_name)
    end

    def stack_exists?(stack_name)
      CloudFormation::Stack.exists?(stack_name)
    end

    def beanstalk_deploy(application, environment, version)
      ElasticBeanstalk::Version.new.deploy(application, environment, version)
    end

    def beanstalk_upload(application, version, version_contents, zip_folder)
      ElasticBeanstalk::Version.new.upload(application, version, version_contents, zip_folder)
    end

    def rds_snapshot(db_instance_id, use_name = false)
      RDS::Snapshot.new(db_instance_id, use_name).create
    end

    def rds_snapshots_delete(db_instance_id, options = nil)
      RDS::Snapshot.new(db_instance_id).delete(options)
    end

    def ec2_image(name, instance_id)
      EC2::Image.new(name).create(instance_id)
    end

  end
end
