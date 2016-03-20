require 'aws_helpers/config'

describe AwsHelpers::Config do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:default_option) { {retry_limit: 8} }

  it 'should call the common config which should add retry_limit = 5' do
    expect(AwsHelpers::Config.new(options).options).to match(hash_including(default_option))
  end

  context '#aws_auto_scaling_client' do
    it 'should create an instance of Aws::AutoScaling::Client' do
      expect(AwsHelpers::Config.new(options).aws_auto_scaling_client).to be_a(Aws::AutoScaling::Client)
    end
  end

  context '#aws_cloud_formation_client' do
    it 'should create an instance of Aws::CloudFormation::Client' do
      expect(AwsHelpers::Config.new(options).aws_cloud_formation_client).to be_a(Aws::CloudFormation::Client)
    end
  end

  context '#aws_ec2_client' do
    it 'should create an instance of Aws::EC2::Client' do
      expect(AwsHelpers::Config.new(options).aws_ec2_client).to be_a(Aws::EC2::Client)
    end
  end

  context '#aws_elastic_beanstalk_client' do
    it 'should create an instance of Aws::ElasticBeanstalk::Client' do
      expect(AwsHelpers::Config.new(options).aws_elastic_beanstalk_client).to be_a(Aws::ElasticBeanstalk::Client)
    end
  end

  context '#aws_elastic_load_balancing_client' do
    it 'should create an instance of Aws::ElasticLoadBalancing::Client' do
      expect(AwsHelpers::Config.new(options).aws_elastic_load_balancing_client).to be_a(Aws::ElasticLoadBalancing::Client)
    end
  end

  context '#aws_iam_client' do
    it 'should create an instance of Aws::IAM::Client' do
      expect(AwsHelpers::Config.new(options).aws_iam_client).to be_a(Aws::IAM::Client)
    end
  end

  context '#aws_rds_client' do
    it 'should create an instance of Aws::RDS::Client' do
      expect(AwsHelpers::Config.new(options).aws_rds_client).to be_a(Aws::RDS::Client)
    end
  end

  context '#aws_s3_client' do
    it 'should create an instance of Aws::S3::Client' do
      expect(AwsHelpers::Config.new(options).aws_s3_client).to be_a(Aws::S3::Client)
    end
  end

  context '#aws_kms_client' do
    it 'should create an instance of Aws::KMS::Client' do
      expect(AwsHelpers::Config.new(options).aws_kms_client).to be_a(Aws::KMS::Client)
    end
  end

end