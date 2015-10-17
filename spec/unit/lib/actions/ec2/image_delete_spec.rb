require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/image_delete'
require 'aws_helpers/actions/ec2/poll_image_deleted'
require 'aws_helpers/actions/ec2/snapshots_delete'

describe AwsHelpers::Actions::EC2::ImageDelete do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:image_id) { 'image_id' }
    let(:poll_image_deleted) { instance_double(AwsHelpers::Actions::EC2::PollImageDeleted) }
    let(:delete_snapshots) { instance_double(AwsHelpers::Actions::EC2::SnapshotsDelete) }

    before(:each) do
      allow(aws_ec2_client).to receive(:describe_images).and_return(create_describe_image_result)
      allow(aws_ec2_client).to receive(:deregister_image)
      allow(AwsHelpers::Actions::EC2::PollImageDeleted).to receive(:new).and_return(poll_image_deleted)
      allow(poll_image_deleted).to receive(:execute)
      allow(AwsHelpers::Actions::EC2::SnapshotsDelete).to receive(:new).and_return(delete_snapshots)
      allow(delete_snapshots).to receive(:execute)
      allow(stdout).to receive(:puts)
    end

    it 'should call Aws::EC2::Client #describe_images with correct parameters' do
      expect(aws_ec2_client).to receive(:describe_images).with(image_ids: [image_id])
      AwsHelpers::Actions::EC2::ImageDelete.new(config, image_id, stdout: stdout).execute
    end

    it 'should call Aws::EC2::Client #deregister_image with correct parameters' do
      expect(aws_ec2_client).to receive(:deregister_image).with(image_id: image_id)
      AwsHelpers::Actions::EC2::ImageDelete.new(config, image_id, stdout: stdout).execute
    end

    it 'should call stdout #puts details of the image being deleted' do
      expect(stdout).to receive(:puts).with("Deleting Image:#{image_id}")
      AwsHelpers::Actions::EC2::ImageDelete.new(config, image_id, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::PollImageDeleted #new with correct parameters' do
      expect(AwsHelpers::Actions::EC2::PollImageDeleted).to receive(:new).with(config, image_id, stdout: stdout)
      AwsHelpers::Actions::EC2::ImageDelete.new(config, image_id, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::PollImageDeleted #execute' do
      expect(poll_image_deleted).to receive(:execute)
      AwsHelpers::Actions::EC2::ImageDelete.new(config, image_id, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::DeleteSnapshots #new with correct parameters' do
      expect(AwsHelpers::Actions::EC2::SnapshotsDelete).to receive(:new).with(config, ['snapshot_id'], stdout: stdout)
      AwsHelpers::Actions::EC2::ImageDelete.new(config, image_id, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::DeleteSnapshots #execute' do
      expect(delete_snapshots).to receive(:execute)
      AwsHelpers::Actions::EC2::ImageDelete.new(config, image_id, stdout: stdout).execute
    end


  end

  def create_describe_image_result
    instance_double(
      Aws::EC2::Types::DescribeImagesResult,
      images: [
        instance_double(
          Aws::EC2::Types::Image,
          block_device_mappings: [
            instance_double(
              Aws::EC2::Types::BlockDeviceMapping,
              ebs:
                instance_double(
                  Aws::EC2::Types::EbsBlockDevice,
                  snapshot_id: 'snapshot_id'
                )
            )
          ]
        )
      ]
    )
  end

end