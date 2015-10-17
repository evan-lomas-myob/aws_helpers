require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/poll_image_deleted'

describe AwsHelpers::Actions::EC2::PollImageDeleted do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:image_id) { 'image_id' }

    before(:each) do
      allow(stdout).to receive(:puts)
    end

    context 'when the image is not returned on the first attempt' do

      before(:each) do
        allow(aws_ec2_client).to receive(:describe_images).and_return(*create_describe_image_results(nil))
      end

      it 'should call Aws::EC2::Client #describe_images with correct parameters' do
        expect(aws_ec2_client).to receive(:describe_images).with(image_ids: [image_id])
        AwsHelpers::Actions::EC2::PollImageDeleted.new(config, image_id, stdout: stdout).execute
      end

      it 'should call stdout #puts with a description of the image being deleted' do
        expect(stdout).to receive(:puts).with("Deleting Image:#{image_id}")
        AwsHelpers::Actions::EC2::PollImageDeleted.new(config, image_id, stdout: stdout).execute
      end

      it 'should call #poll with correct defaults for delay and max_attempts' do
        poll_image_exists = AwsHelpers::Actions::EC2::PollImageDeleted.new(config, image_id, stdout: stdout)
        expect(poll_image_exists).to receive(:poll).with(15, 4)
        poll_image_exists.execute
      end

      it 'should call #poll correctly with optional max_attempts' do
        poll_image_exists = AwsHelpers::Actions::EC2::PollImageDeleted.new(config, image_id, stdout: stdout, max_attempts: 1)
        expect(poll_image_exists).to receive(:poll).with(15, 1)
        poll_image_exists.execute
      end

      it 'should call #poll correctly with optional delay' do
        poll_image_exists = AwsHelpers::Actions::EC2::PollImageDeleted.new(config, image_id, stdout: stdout, delay: 1)
        expect(poll_image_exists).to receive(:poll).with(1, 4)
        poll_image_exists.execute
      end

    end

    context 'when the image is returned in the first attempt' do

      before(:each) do
        allow(aws_ec2_client).to receive(:describe_images).and_return(*create_describe_image_results(create_image('available'), nil))
      end

      it 'should call stdout #puts with a description of the image being deleted and state when the image is still found' do
        expect(stdout).to receive(:puts).with("Deleting Image:#{image_id} State:available")
        AwsHelpers::Actions::EC2::PollImageDeleted.new(config, image_id, delay:0, stdout: stdout).execute
      end

    end

  end

  def create_image(state)
    instance_double(
      Aws::EC2::Types::Image,
      state: state
    )
  end

  def create_describe_image_results(*images)
    images.map { |image|
      instance_double(
        Aws::EC2::Types::DescribeImagesResult,
        images: [image].compact
      )
    }
  end

end