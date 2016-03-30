require 'aws-sdk-core'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_exists'

include AwsHelpers::Actions::EC2

describe PollInstanceExists do
  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:instance_id) { 'i-de42f500' }
  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 2 }

  let(:options) { { stdout: stdout, delay: 0, max_attempts: max_attempts } }

  describe '#execute' do
    it 'should use the AwsHelpers::Utilities::Polling to poll until the image exists' do
      expect(aws_ec2_client).to receive(:describe_instances)
      PollInstanceExists.new(config, instance_id, options).execute
    end

    it 'should raise an exception is polling reaches max attempts and instance is not found' do
      allow(aws_ec2_client).to receive(:describe_instances).and_raise(Aws::EC2::Errors::InvalidInstanceIDNotFound.new(nil, nil))
      expect { PollInstanceExists.new(config, instance_id, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end
  end
end
