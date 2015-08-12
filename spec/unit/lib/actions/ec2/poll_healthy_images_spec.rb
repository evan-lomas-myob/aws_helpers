require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/poll_healthy_images'

include AwsHelpers::Actions::EC2

describe PollHealthyImages do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
  let(:stdout) { instance_double(IO) }
  let(:waiter) { instance_double(Aws::Waiters::Waiter, delay: 15, max_attempts: 40) }
  let(:instance_id) { 'i-abcd1234' }
  let(:response) {
    double(:instance_statuses,
           instance_statuses:
               [
                   double(:instance_state, instance_state:
                                             double(:name, name: 'running')
                   )
               ]
    )
  }

  describe '#execute' do

    before(:each) do
      allow(aws_ec2_client).to receive(:wait_until).and_yield(waiter)
      allow(waiter).to receive(:max_attempts=)
      allow(waiter).to receive(:before_wait).and_yield(1, response)
      allow(stdout).to receive(:puts)
    end

    it 'should call describe wait_until with correct parameters on the AWS::EC2::Client' do
      expect(aws_ec2_client).to receive(:wait_until).with(:instance_status_ok, instance_id: [instance_id])
      PollHealthyImages.new(stdout, config, instance_id, 1, 60).execute
    end

    it 'should set the waiters max attempts to 4' do
      expect(waiter).to receive(:max_attempts=).with(4)
      PollHealthyImages.new(stdout, config, instance_id, 1, 60).execute
    end

    it 'log to stdout' do
      expect(stdout).to receive(:puts).with('Image State is running')
      PollHealthyImages.new(stdout, config, instance_id, 1, 60).execute
    end

  end

end