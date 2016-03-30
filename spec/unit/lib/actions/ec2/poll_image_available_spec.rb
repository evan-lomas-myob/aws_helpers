require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/poll_image_available'
require 'aws_helpers/actions/ec2/snapshots_describe'

describe AwsHelpers::Actions::EC2::PollImageAvailable do
  describe '#execute' do
    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:image_id) { 'image_id' }
    let(:describe_snapshots) { instance_double(AwsHelpers::Actions::EC2::SnapshotsDescribe) }

    context 'image state available on first call to (Aws::EC2::Client #describe_images' do
      before(:each) do
        allow(aws_ec2_client).to receive(:describe_images).and_return(*create_describe_images_results('available'))
        allow(AwsHelpers::Actions::EC2::SnapshotsDescribe).to receive(:new).and_return(describe_snapshots)
        allow(describe_snapshots).to receive(:execute)
        allow(stdout).to receive(:puts)
      end

      it 'should call the Aws::EC2::Client #describe_images with correct parameters' do
        expect(aws_ec2_client).to receive(:describe_images).with(image_ids: [image_id])
        AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout).execute
      end

      it 'should call stdout #puts with a description of the image in the available state' do
        expect(stdout).to receive(:puts).with("Image:#{image_id} State:available")
        AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout).execute
      end

      it 'should call #poll with correct defaults for delay and max_attempts' do
        poll_image_exists = AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout)
        expect(poll_image_exists).to receive(:poll).with(30, 20)
        poll_image_exists.execute
      end

      it 'should call #poll correctly with optional max_attempts' do
        poll_image_exists = AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout, max_attempts: 1)
        expect(poll_image_exists).to receive(:poll).with(30, 1)
        poll_image_exists.execute
      end

      it 'should call #poll correctly with optional delay' do
        poll_image_exists = AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout, delay: 1)
        expect(poll_image_exists).to receive(:poll).with(1, 20)
        poll_image_exists.execute
      end

      it 'should call AwsHelpers::Actions::EC2::DescribeSnapshots #new with correct parameters' do
        expect(AwsHelpers::Actions::EC2::SnapshotsDescribe).to receive(:new).with(config, ['snapshot_id'])
        AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout).execute
      end

      it 'should call AwsHelpers::Actions::EC2::DescribeSnapshots #execute' do
        expect(describe_snapshots).to receive(:execute)
        AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout).execute
      end
    end

    context 'image available after multiple calls to Aws::EC2::Client #describe_images' do
      before(:each) do
        allow(aws_ec2_client)
          .to receive(:describe_images)
          .and_return(*create_describe_images_results('pending', 'pending', 'pending', 'available'))
        allow(AwsHelpers::Actions::EC2::SnapshotsDescribe).to receive(:new).and_return(describe_snapshots)
        allow(describe_snapshots).to receive(:execute)
        allow(stdout).to receive(:puts)
      end

      it 'should call stdout #puts with a description of the image in the pending state' do
        expect(stdout).to receive(:puts).with("Waiting for Image:#{image_id} State:pending to become available 0.0 seconds").once
        expect(stdout).to receive(:puts).with("Waiting for Image:#{image_id} State:pending to become available 0.01 seconds").once
        expect(stdout).to receive(:puts).with("Waiting for Image:#{image_id} State:pending to become available 0.02 seconds").once
        AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout, delay: 0.01).execute
      end

      it 'should call the Aws::EC2::Client #describe_images multiple times until the image is available' do
        expect(aws_ec2_client).to receive(:describe_images).exactly(4).times
        AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout, delay: 0).execute
      end
    end

    context 'image still pending after calls to Aws::EC2::Client #describe_images exceeds retries' do
      before(:each) do
        allow(aws_ec2_client).to receive(:describe_images).and_return(*create_describe_images_results('pending'))
        allow(AwsHelpers::Actions::EC2::SnapshotsDescribe).to receive(:new).and_return(describe_snapshots)
        allow(describe_snapshots).to receive(:execute)
        allow(stdout).to receive(:puts)
      end

      it 'should call the Aws::EC2::Client #describe_images multiple times until the image is returned' do
        poll = AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout, max_attempts: 1, delay: 0)
        expect { poll.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
      end

      it 'should call AwsHelpers::Actions::EC2::DescribeSnapshots #new with correct parameters' do
        expect(AwsHelpers::Actions::EC2::SnapshotsDescribe).to receive(:new).with(config, ['snapshot_id'])
        begin
          AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout, max_attempts: 1, delay: 0).execute
        rescue # rubocop:disable Lint/HandleExceptions
          # ignored
        end
      end
    end

    context 'unexpected state after call to Aws::EC2::Client #describe_images' do
      it 'should raise an AwsHelpers::Utilities::FailedStateError error' do
        allow(aws_ec2_client).to receive(:describe_images).and_return(*create_describe_images_results('unexpected'))
        allow(stdout).to receive(:puts)
        poll = AwsHelpers::Actions::EC2::PollImageAvailable.new(config, image_id, stdout: stdout, max_attempts: 1, delay: 0)
        expect { poll.execute }.to raise_error(AwsHelpers::Utilities::FailedStateError, "Image:#{image_id} State:unexpected")
      end
    end
  end

  def create_describe_images_results(*states)
    ebs_double = instance_double(Aws::EC2::Types::EbsBlockDevice, snapshot_id: 'snapshot_id')
    block_double = instance_double(Aws::EC2::Types::BlockDeviceMapping, ebs: ebs_double)
    states.map do |state|
      instance_double(
        Aws::EC2::Types::DescribeImagesResult,
        images: [
          instance_double(Aws::EC2::Types::Image, state: state, block_device_mappings: [block_double])
        ]
      )
    end
  end
end
