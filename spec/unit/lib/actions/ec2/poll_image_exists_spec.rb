require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/poll_image_exists'

describe AwsHelpers::Actions::EC2::PollImageExists do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:image_id) { 'image_id' }
    let(:empty_describe_images_result) { instance_double(Aws::EC2::Types::DescribeImagesResult, images: []) }
    let(:found_describe_images_result) { instance_double(Aws::EC2::Types::DescribeImagesResult, images: [instance_double(Aws::EC2::Types::Image)]) }

    context 'image found on first call to aws_ec2_client #describe_images' do

      before(:each) do
        allow(aws_ec2_client).to receive(:describe_images).and_return(found_describe_images_result)
        allow(stdout).to receive(:puts)
      end

      it 'should call the aws_ec2_client #describe_images with correct parameters' do
        expect(aws_ec2_client).to receive(:describe_images).with(image_ids: [image_id])
        AwsHelpers::Actions::EC2::PollImageExists.new(config, image_id, stdout: stdout).execute
      end

      it 'should call stdout #puts with a description of the image it is waiting for' do
        expect(stdout).to receive(:puts).with("Waiting for Image:#{image_id}")
        AwsHelpers::Actions::EC2::PollImageExists.new(config, image_id, stdout: stdout).execute
      end

      it 'should call its poll method with defaults for max_attempts and poll' do
        poll_image_exists = AwsHelpers::Actions::EC2::PollImageExists.new(config, image_id, stdout: stdout)
        expect(poll_image_exists).to receive(:poll).with(10, 3)
        poll_image_exists.execute
      end

      it 'should call its poll method correctly with optional max_attempts' do
        poll_image_exists = AwsHelpers::Actions::EC2::PollImageExists.new(config, image_id, stdout: stdout, max_attempts: 1)
        expect(poll_image_exists).to receive(:poll).with(10, 1)
        poll_image_exists.execute
      end

      it 'should call its poll method correctly with optional delay' do
        poll_image_exists = AwsHelpers::Actions::EC2::PollImageExists.new(config, image_id, stdout: stdout, delay: 1)
        expect(poll_image_exists).to receive(:poll).with(1, 3)
        poll_image_exists.execute
      end

    end

    context 'image found after multiple calls to aws_ec2_client #describe_images' do

      before(:each) do
        allow(aws_ec2_client).to receive(:describe_images).and_return(empty_describe_images_result, found_describe_images_result)
        allow(stdout).to receive(:puts)
      end

      it 'should call the aws_ec2_client #describe_images multiple times until the image is returned' do
        expect(aws_ec2_client).to receive(:describe_images).twice
        AwsHelpers::Actions::EC2::PollImageExists.new(config, image_id, stdout: stdout, delay: 0).execute
      end

    end

    context 'image not found after calls to aws_ec2_client #describe_images exceeds retries' do

      before(:each) do
        allow(aws_ec2_client).to receive(:describe_images).and_return(empty_describe_images_result)
        allow(stdout).to receive(:puts)
      end

      it 'should call the aws_ec2_client #describe_images multiple times until the image is returned' do
        expect {
          AwsHelpers::Actions::EC2::PollImageExists.new(config, image_id, stdout: stdout, max_attempts: 1, delay: 0).execute
        }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
      end

    end

  end

end
