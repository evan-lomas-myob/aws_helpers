require 'aws-sdk-core'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_state'

include AwsHelpers::Actions::EC2

describe PollInstanceTagValue do
  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:instance_id) { 'i-de42f500' }
  let(:tag_key) { 'status' }
  let(:tag_value) { 'COMPLETE' }
  let(:instance) { Aws::EC2::Types::Instance.new(instance_id: instance_id,
                                                 state: Aws::EC2::Types::InstanceState.new(name: "running"),
                                                 tags: Aws::EC2::Tag.new()
                  )}


  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 2 }
  let(:options) { { stdout: stdout, delay: 0, max_attempts: max_attempts } }

  describe '#execute' do
    before(:each) do
      allow(stdout).to receive(:puts)
    end

    it 'should use the AwsHelpers::Utilities::Polling to poll until the tag value for the specified tag key is in the expect state' do
      expect(aws_ec2_client).to receive(:describe_instances).with(instance_ids: [instance_id]).and_return(
        create_status_result(is_running), create_status_result(is_stopped)
      )
      PollInstanceTagValue.new(config, instance_id, is_stopped, options).execute
    end

    it 'should raise an exception is polling reaches max attempts' do
      allow(aws_ec2_client).to receive(:describe_instances).and_return(create_status_result(is_running))
      expect { PollInstanceTagValue.new(config, instance_id, is_stopped, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end

    it 'should write the status to stdout' do
      expect(stdout).to receive(:puts).with("Instance State is #{is_stopped}.")
      allow(aws_ec2_client).to receive(:describe_instances).and_return(create_status_result(is_stopped))
      PollInstanceStPollInstanceTagValueate.new(config, instance_id, is_stopped, options).execute
    end
  end

  def create_status_result(status)
    state = Aws::EC2::Types::InstanceState.new(name: status)
    instance = Aws::EC2::Types::Instance.new(state: state)
    Aws::EC2::Types::DescribeInstancesResult.new(
      reservations: [
        Aws::EC2::Types::Reservation.new(instances: [instance])
      ])
  end
end
