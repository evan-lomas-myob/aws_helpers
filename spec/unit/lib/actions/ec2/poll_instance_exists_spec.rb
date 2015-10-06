require 'aws-sdk-core'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_exists'

include AwsHelpers::Actions::EC2

describe PollInstanceExists do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:instance_id) { 'i-de42f500' }

  let(:instance_noexists) { instance_double(Aws::EC2::Instance, exists?: false) }
  let(:instance_exists) { instance_double(Aws::EC2::Instance, exists?: true) }

  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 2 }
  let(:delay) { 0 }

  let(:options) { {stdout: stdout, delay: delay, max_attempts: max_attempts} }

  describe '#execute' do

    it 'should use the AwsHelpers::Utilities::Polling to poll until the image exists' do
      expect(Aws::EC2::Instance).to receive(:new).and_return(instance_noexists, instance_exists)
      PollInstanceExists.new(instance_id, options).execute
    end

    it 'should raise an exception is polling reaches max attempts' do
      allow(Aws::EC2::Instance).to receive(:new).and_return(instance_noexists)
      expect{ PollInstanceExists.new(instance_id, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end

  end

end