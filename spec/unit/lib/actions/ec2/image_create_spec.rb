require 'time'
require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/image_create'
require 'aws_helpers/actions/ec2/poll_healthy_instances'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe ImageCreate do

  describe '#ImageCreate' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

    let(:stdout) { instance_double(IO) }

    let(:image_id) { 'ami-abcd1234' }

    let(:instance_id) { 'i-abcd1234' }
    let(:instance_name) { 'an_instance_name_referring_to_app' }

    let(:additional_tag_name) { 'additional_tag_key' }
    let(:additional_tag_value) { 'additional_tag_value' }

    let(:instance_state_good) { instance_double(Aws::EC2::Types::InstanceState, name: 'running') }
    let(:instance_statuses_good) { [instance_double(Aws::EC2::Types::InstanceStatus, instance_state: instance_state_good)] }
    let(:describe_instance_status_result_good) { instance_double(Aws::EC2::Types::DescribeInstanceStatusResult, instance_statuses: instance_statuses_good) }

    let(:state_bad) { 'terminated'}
    let(:instance_state_bad) { instance_double(Aws::EC2::Types::InstanceState, name: state_bad) }
    let(:instance_statuses_bad) { [instance_double(Aws::EC2::Types::InstanceStatus, instance_state: instance_state_bad)] }
    let(:describe_instance_status_result_bad) { instance_double(Aws::EC2::Types::DescribeInstanceStatusResult, instance_statuses: instance_statuses_bad) }

    let (:additional_tags) { [
        {key: 'Key', value: additional_tag_name},
        {key: 'Value', value: additional_tag_value}
    ] }

    let(:now) { Time.parse('01-Jan-2015 00:00:00') }

    before(:each) do
      allow(aws_ec2_client).to receive(:create_image).with(instance_id: instance_id, name: instance_name).and_return(image_id)
      allow(aws_ec2_client).to receive(:create_tags).with(resources: [image_id], tags: [{key: 'Name', value: instance_name}, {key: 'Date', value: now.to_s}] + additional_tags)
    end

    context 'instances is in a good state to get an image' do

      after(:each) do
        ImageCreate.new(config, instance_id, instance_name, additional_tags, now, stdout).execute
      end

      it 'should call the client create_image method with the correct arguments and return the image id' do
        allow(aws_ec2_client).to receive(:describe_instance_status).with(instance_ids: [instance_id]).and_return(describe_instance_status_result_good)
        expect(aws_ec2_client).to receive(:create_image).with(instance_id: instance_id, name: instance_name).and_return(image_id)
      end

      it 'should use the image id to add a default tag + additional tags to the new image' do
        allow(aws_ec2_client).to receive(:describe_instance_status).with(instance_ids: [instance_id]).and_return(describe_instance_status_result_good)
        expect(aws_ec2_client).to receive(:create_tags).with(resources: [image_id], tags: [{key: 'Name', value: instance_name}, {key: 'Date', value: now.to_s}] + additional_tags)
      end

    end

    context 'instances is in a bad state to get an image' do

      it 'should raise an exception when the instance is not in a desirable state' do
        allow(aws_ec2_client).to receive(:describe_instance_status).with(instance_ids: [instance_id]).and_return(describe_instance_status_result_bad)
        expect { ImageCreate.new(config, instance_id, instance_name, additional_tags, now, stdout).execute }.to raise_error("AMI creation from #{instance_id} failed. State is #{state_bad}")
      end

    end
  end

end
