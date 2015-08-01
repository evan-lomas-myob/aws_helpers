module AwsHelpers

  class Config < AwsHelpers::Common::Config

    attr_accessor :aws_auto_scaling_client
    attr_accessor :aws_cloud_formation_client
    attr_accessor :aws_ec2_client
    attr_accessor :aws_elastic_beanstalk_client
    attr_accessor :aws_elastic_load_balancing_client
    attr_accessor :aws_iam_client
    attr_accessor :aws_s3_client

    # @param options [Hash] Optional arguments to pass to the AWS Ruby SDK
    def initialize(options)
      super(options)
    end

    # @return [Aws::AutoScaling::Client]
    def aws_auto_scaling_client
      @aws_auto_scaling_client ||= Aws::AutoScaling::Client.new(options)
    end

    # @return [Aws::CloudFormation::Client]
    def aws_cloud_formation_client
      @aws_cloud_formation_client = Aws::CloudFormation::Client.new(options)
    end

    # @return [Aws::EC2::Client]
    def aws_ec2_client
      @aws_ec2_client ||= Aws::EC2::Client.new(options)
    end

    def aws_elastic_beanstalk_client
      @aws_elastic_beanstalk_client ||= Aws::ElasticBeanstalk::Client.new(options)
    end

    # @return [Aws::ElasticLoadBalancing::Client]
    def aws_elastic_load_balancing_client
      @aws_elastic_load_balancing_client ||= Aws::ElasticLoadBalancing::Client.new(options)
    end

    def aws_iam_client
      @aws_iam_client ||= Aws::IAM::Client.new(options)
    end

    # @return [Aws::S3::Client]
    def aws_s3_client
      @aws_s3_client = Aws::S3::Client.new(options)
    end

  end

end