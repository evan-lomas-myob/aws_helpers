require 'aws_helpers/version'
require 'aws-sdk-core'
require_relative 'aws_helpers/cloud_formation/stack_provision'
require_relative 'aws_helpers/cloud_formation/stack_modify_parameters'
require_relative 'aws_helpers/cloud_formation/stack_delete'
require_relative 'aws_helpers/cloud_formation/stack_exists'
require_relative 'aws_helpers/cloud_formation/stack_outputs'
require_relative 'aws_helpers/elastic_load_balancing/poll_healthy_instances'
require_relative 'aws_helpers/elastic_beanstalk/version'
require_relative 'aws_helpers/rds/instance'
require_relative 'aws_helpers/ec2/image'
require_relative 'aws_helpers/auto_scaling_group/retrieve_desired_capacity'
require_relative 'aws_helpers/auto_scaling_group/update_desired_capacity'

module AwsHelpers
  extend self

  class << self

    COMMON_OPTIONS = { retry_limit: 4 }

    def stack_provision(stack_name, template, options = {})
      cloud_formation_client = Aws::CloudFormation::Client.new(COMMON_OPTIONS)
      s3_client = Aws::S3::Client.new(COMMON_OPTIONS)
      CloudFormation::StackProvision.new(cloud_formation_client, s3_client, stack_name, template, options).execute
    end

    def stack_s3_provision(stack_name, template, bucket_name, options = {}, bucket_encrypt = false)
      cloud_formation_client = Aws::CloudFormation::Client.new(COMMON_OPTIONS)
      s3_client = Aws::S3::Client.new(COMMON_OPTIONS)
      CloudFormation::StackProvision.new(cloud_formation_client, s3_client, stack_name, template, options.merge(bucket_name: bucket_name, bucket_encrypt: bucket_encrypt)).execute
    end

    def stack_modify_parameters(stack_name, parameters)
      cloud_formation_client = Aws::CloudFormation::Client.new(COMMON_OPTIONS)
      CloudFormation::StackModifyParameters.new(cloud_formation_client, stack_name, parameters).execute
    end

    def stack_delete(stack_name)
      cloud_formation_client = Aws::CloudFormation::Client.new(COMMON_OPTIONS)
      CloudFormation::StackDelete.new(cloud_formation_client, stack_name).execute
    end

    def stack_outputs(stack_name)
      cloud_formation_client = Aws::CloudFormation::Client.new(COMMON_OPTIONS)
      CloudFormation::StackOutputs.new(cloud_formation_client, stack_name).execute
    end

    def stack_exists?(stack_name)
      cloud_formation_client = Aws::CloudFormation::Client.new(COMMON_OPTIONS)
      CloudFormation::StackExists.new(cloud_formation_client, stack_name).execute
    end

    def elb_poll_healthy_instances(load_balancer_name, required_instances, timeout)
      elastic_load_balancing_client = Aws::ElasticLoadBalancing::Client.new(COMMON_OPTIONS)
      ElasticLoadBalancing::PollHealthyInstances.new(elastic_load_balancing_client, load_balancer_name, required_instances, timeout).execute
    end

    def auto_scaling_group_retrieve_desired_capacity(auto_scaling_group_name)
      auto_scaling_client = Aws::AutoScaling::Client.new(COMMON_OPTIONS)
      AutoScalingGroup::RetrieveDesiredCapacity.new(auto_scaling_client, auto_scaling_group_name).execute
    end

    def auto_scaling_group_update_desired_capacity(auto_scaling_group_name, desired_capacity, timeout)
      autoscaling_client = Aws::AutoScaling::Client.new(COMMON_OPTIONS)
      elastic_load_balancing_client = Aws::ElasticLoadBalancing::Client.new(COMMON_OPTIONS)
      AutoScalingGroup::UpdateDesiredCapacity.new(autoscaling_client, elastic_load_balancing_client, auto_scaling_group_name, desired_capacity, timeout).execute
    end

    def beanstalk_deploy(application, environment, version)
      elastic_beanstalk_client = Aws::ElasticBeanstalk::Client.new(COMMON_OPTIONS)
      s3_client = Aws::S3::Client.new(COMMON_OPTIONS)
      iam_client = Aws::IAM::Client.new(COMMON_OPTIONS)
      ElasticBeanstalk::Version.new(elastic_beanstalk_client, s3_client, iam_client).deploy(application, environment, version)
    end

    def beanstalk_upload(application, version, version_contents, zip_folder)
      elastic_beanstalk_client = Aws::ElasticBeanstalk::Client.new(COMMON_OPTIONS)
      s3_client = Aws::S3::Client.new(COMMON_OPTIONS)
      iam_client = Aws::IAM::Client.new(COMMON_OPTIONS)
      ElasticBeanstalk::Version.new(elastic_beanstalk_client, s3_client, iam_client).upload(application, version, version_contents, zip_folder)
    end

    def rds_snapshot_create(db_instance_id, use_name = false)
      rds_client = Aws::RDS::Client.new(COMMON_OPTIONS)
      iam_client = Aws::IAM::Client.new(COMMON_OPTIONS)
      RDS::Snapshot.new(rds_client, iam_client, db_instance_id, use_name).create
    end

    def rds_snapshots_delete(db_instance_id, options = nil)
      rds_client = Aws::RDS::Client.new(COMMON_OPTIONS)
      iam_client = Aws::IAM::Client.new(COMMON_OPTIONS)
      RDS::Snapshot.new(rds_client, iam_client, db_instance_id).delete(options)
    end

    def rds_snapshot_latest(db_instance_id)
      rds_client = Aws::RDS::Client.new(COMMON_OPTIONS)
      iam_client = Aws::IAM::Client.new(COMMON_OPTIONS)
      RDS::Snapshot.new(rds_client, iam_client, db_instance_id).latest
    end

    def ec2_image_create(name, instance_id, additional_tags = [])
      ec2_client = Aws::EC2::Client.new(COMMON_OPTIONS)
      EC2::Image.new(ec2_client).create(instance_id, name, additional_tags)
    end

    def ec2_images_delete(name, options = nil)
      ec2_client = Aws::EC2::Client.new(COMMON_OPTIONS)
      EC2::Image.new(ec2_client).delete(name, options)
    end

    def ec2_images_delete_by_time(name, time)
      ec2_client = Aws::EC2::Client.new(COMMON_OPTIONS)
      EC2::Image.new(ec2_client).delete_by_time(name, time)
    end

    def ec2_images_find_by_tags(tags)
      ec2_client = Aws::EC2::Client.new(COMMON_OPTIONS)
      EC2::Image.new(ec2_client).find_by_tag(tags)
    end

  end
end
