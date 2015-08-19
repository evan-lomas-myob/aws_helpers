require 'time'
require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/image_create'
require 'aws_helpers/actions/ec2/poll_healthy_images'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe ImageCreate do

  describe '#ImageCreate' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:waiter) { instance_double(Aws::Waiters::Waiter, delay: 15, max_attempts: 40) }

    let(:poll_healthy_images) { instance_double(PollHealthyImages) }
    let(:stdout) { instance_double(IO) }

    let(:image_id) { 'ami-abcd1234' }

    let(:instance_id) { 'i-abcd1234' }
    let(:instance_name) { 'an_instance_name_referring_to_app' }

    let(:additional_tag_name) { 'additional_tag_key' }
    let(:additional_tag_value) { 'additional_tag_value' }

    let (:additional_tags) { [
        {key: 'Key', value: additional_tag_name},
        {key: 'Value', value: additional_tag_value}
    ] }

    let(:now) { Time.parse('01-Jan-2015 00:00:00') }

    before(:each) do
      allow(aws_ec2_client).to receive(:create_image).with(instance_id: instance_id, name: instance_name).and_return(image_id)
      allow(aws_ec2_client).to receive(:create_tags).with(resources: [image_id], tags: [{key: 'Name', value: instance_name}, {key: 'Date', value: now.to_s}] + additional_tags)
      allow(PollHealthyImages).to receive(:new).with(config, instance_id, 1, 60).and_return(poll_healthy_images)
      allow(poll_healthy_images).to receive(:execute)
    end

    after(:each) do
      ImageCreate.new(config, instance_id, instance_name, additional_tags, now, stdout).execute
    end

    it 'should call the client create_image method with the correct arguments and return the image id' do
      expect(aws_ec2_client).to receive(:create_image).with(instance_id: instance_id, name: instance_name).and_return(image_id)
    end

    it 'should use the image id to add a default tag + additional tags to the new image' do
      expect(aws_ec2_client).to receive(:create_tags).with(resources: [image_id], tags: [{key: 'Name', value: instance_name}, {key: 'Date', value: now.to_s}] + additional_tags)
    end

    it 'should call PollHealthyImages until they are available' do
      expect(poll_healthy_images).to receive(:execute)
    end

  end

end
