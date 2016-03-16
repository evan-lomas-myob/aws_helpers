require 'aws_helpers/version'
require 'aws-sdk-core'
require_relative 'aws_helpers/cloud_formation/stack_provision'
require_relative 'aws_helpers/cloud_formation/stack_modify_parameters'
require_relative 'aws_helpers/cloud_formation/stack_delete'
require_relative 'aws_helpers/cloud_formation/stack_exists'
require_relative 'aws_helpers/cloud_formation/stack_outputs'
require_relative 'aws_helpers/cloud_formation/stack_parameters'
require_relative 'aws_helpers/elastic_load_balancing/poll_healthy_instances'
require_relative 'aws_helpers/elastic_load_balancing/poll_max_healthy_instances'
require_relative 'aws_helpers/elastic_load_balancing/create_tag'
require_relative 'aws_helpers/elastic_load_balancing/read_tag'
require_relative 'aws_helpers/elastic_load_balancing/instance'
require_relative 'aws_helpers/elastic_beanstalk/version'
require_relative 'aws_helpers/rds/instance'
require_relative 'aws_helpers/ec2/image'
require_relative 'aws_helpers/ec2/utils'
require_relative 'aws_helpers/auto_scaling_group/drain_instances'
require_relative 'aws_helpers/auto_scaling_group/retrieve_desired_capacity'
require_relative 'aws_helpers/auto_scaling_group/retrieve_group_configuration'
require_relative 'aws_helpers/auto_scaling_group/resume_alarm_process'
require_relative 'aws_helpers/auto_scaling_group/suspend_alarm_process'
require_relative 'aws_helpers/auto_scaling_group/update_desired_capacity'
require_relative 'aws_helpers/auto_scaling_group/update_minmax_capacity'


module AwsHelpers
  extend self

  class << self

    COMMON_OPTIONS = { retry_limit: 5 }

    def stack_provision(stack_name, template, options = {})
      CloudFormation::StackProvision.new(cf_client, s3_client, stack_name, template, options).execute
    end

    def stack_s3_provision(stack_name, template, bucket_name, options = {}, bucket_encrypt = false)
      CloudFormation::StackProvision.new(cf_client, s3_client, stack_name, template, options.merge(bucket_name: bucket_name, bucket_encrypt: bucket_encrypt)).execute
    end

    def stack_modify_parameters(stack_name, parameters)
      CloudFormation::StackModifyParameters.new(cf_client, stack_name, parameters).execute
    end

    def stack_delete(stack_name)
      CloudFormation::StackDelete.new(cf_client, stack_name).execute
    end

    def stack_outputs(stack_name)
      CloudFormation::StackOutputs.new(cf_client, stack_name).execute
    end

    def stack_parameters(stack_name)
      CloudFormation::StackParameters.new(cf_client, stack_name).execute
    end

    def stack_exists?(stack_name)
      CloudFormation::StackExists.new(cf_client, stack_name).execute
    end

    def elb_poll_healthy_instances(load_balancer_name, required_instances, timeout)
      ElasticLoadBalancing::PollHealthyInstances.new(elb_client, load_balancer_name, required_instances, timeout).execute
    end

    def elb_poll_max_healthy_instances(load_balancer_name, required_instances, timeout)
      ElasticLoadBalancing::PollMaxHealthyInstances.new(elb_client, load_balancer_name, required_instances, timeout).execute
    end

    def elb_create_tag(load_balancer_name, tag_key, tag_value)
      ElasticLoadBalancing::CreateTag.new(elb_client, load_balancer_name, tag_key, tag_value).execute
    end

    def elb_read_tag(load_balancer_name, tag_key)
      ElasticLoadBalancing::ReadTag.new(elb_client, load_balancer_name, tag_key).execute
    end

    def elb_get_instances(load_balancer_name)
      ElasticLoadBalancing::Instance.new(elb_client, load_balancer_name).execute
    end

    def auto_scaling_group_retrieve_desired_capacity(auto_scaling_group_name)
      AutoScalingGroup::RetrieveDesiredCapacity.new(auto_scaling_client, auto_scaling_group_name).execute
    end

    def auto_scaling_group_retrieve_group_configuration(auto_scaling_group_name)
      AutoScalingGroup::RetrieveGroupConfiguration.new(auto_scaling_client, auto_scaling_group_name).execute
    end

    def auto_scaling_group_drain_instances(auto_scaling_group_name)
      AutoScalingGroup::DrainInstances.new(auto_scaling_client, auto_scaling_group_name).execute
    end

    def auto_scaling_group_suspend_alarm_process(auto_scaling_group_name)
      AutoScalingGroup::SuspendAlarmProcess.new(auto_scaling_client, auto_scaling_group_name).execute
    end

    def auto_scaling_group_resume_alarm_process(auto_scaling_group_name)
      AutoScalingGroup::ResumeAlarmProcess.new(auto_scaling_client, auto_scaling_group_name).execute
    end

    def auto_scaling_group_update_desired_capacity(auto_scaling_group_name, desired_capacity, timeout)
      AutoScalingGroup::UpdateDesiredCapacity.new(auto_scaling_client, elb_client, auto_scaling_group_name, desired_capacity, timeout).execute
    end

    def auto_scaling_group_update_minmax_capacity(auto_scaling_group_name, min_size, max_size)
      AutoScalingGroup::UpdateMinMaxCapacity.new(auto_scaling_client, auto_scaling_group_name, min_size, max_size).execute
    end

    def beanstalk_deploy(application, environment, version)
      ElasticBeanstalk::Version.new(elastic_beanstalk_client, s3_client, iam_client).deploy(application, environment, version)
    end

    def beanstalk_upload(application, version, version_contents, zip_folder)
      ElasticBeanstalk::Version.new(elastic_beanstalk_client, s3_client, iam_client).upload(application, version, version_contents, zip_folder)
    end

    def rds_snapshot_create(db_instance_id, use_name = false)
      RDS::Snapshot.new(rds_client, iam_client, db_instance_id, use_name).create
    end

    def rds_snapshots_delete(db_instance_id, options = nil)
      RDS::Snapshot.new(rds_client, iam_client, db_instance_id).delete(options)
    end

    def rds_snapshot_latest(db_instance_id)
      RDS::Snapshot.new(rds_client, iam_client, db_instance_id).latest
    end

    def ec2_image_create(name, instance_id, additional_tags = [])
      EC2::Image.new(ec2_client).create(instance_id, name, additional_tags)
    end

    def ec2_image_add_user(image_id, user_id)
      EC2::Image.new(ec2_client).image_add_user(image_id, user_id, options={})
    end

    def ec2_images_delete(name, options = nil)
      EC2::Image.new(ec2_client).delete(name, options)
    end

    def ec2_images_delete_by_time(name, time)
      EC2::Image.new(ec2_client).delete_by_time(name, time)
    end

    def ec2_images_find_by_tags(tags)
      EC2::Image.new(ec2_client).find_by_tag(tags)
    end

    def ec2_get_windows_password(instance_id)
      EC2::Utils.new(ec2_client).get_windows_password(instance_id)
    end
    
    def ec2_get_decrypted_windows_password(instance_id, private_keyfile)
      EC2::Utils.new(ec2_client).get_decrypted_windows_password(instance_id, private_keyfile)
    end
    
    private

    def cf_client
      @cloud_formation_client ||= Aws::CloudFormation::Client.new(COMMON_OPTIONS)
    end

    def s3_client
      @s3_client ||= Aws::S3::Client.new(COMMON_OPTIONS)
    end

    def elb_client
      @elb_client ||= Aws::ElasticLoadBalancing::Client.new(COMMON_OPTIONS)
    end

    def auto_scaling_client
      @auto_scaling_client ||= Aws::AutoScaling::Client.new(COMMON_OPTIONS)
    end

    def elastic_beanstalk_client
      @elastic_beanstalk_client ||= Aws::ElasticBeanstalk::Client.new(COMMON_OPTIONS)
    end

    def iam_client
      @iam_client ||= Aws::IAM::Client.new(COMMON_OPTIONS)
    end

    def rds_client
      @rds_client ||= Aws::RDS::Client.new(COMMON_OPTIONS)
    end

    def ec2_client
      @ec2_client ||= Aws::EC2::Client.new(COMMON_OPTIONS)
    end
  end
end
