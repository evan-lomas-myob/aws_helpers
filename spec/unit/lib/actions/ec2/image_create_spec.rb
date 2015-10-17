require 'time'
require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/image_create'
require 'aws_helpers/actions/ec2/tag_image'

describe AwsHelpers::Actions::EC2::ImageCreate do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:now) { Time.now }
    let(:name) { 'name' }
    let(:ami_name) { "#{name} #{now.strftime('%Y-%m-%d-%H-%M')}" }
    let(:image_id) { 'image_id' }
    let(:create_image_response) { instance_double(Aws::EC2::Types::CreateImageResult, image_id: image_id) }
    let(:poll_image_exists) { instance_double(AwsHelpers::Actions::EC2::PollImageExists) }
    let(:tag_image) { instance_double(AwsHelpers::Actions::EC2::TagImage) }
    let(:poll_image_available) { instance_double(AwsHelpers::Actions::EC2::PollImageAvailable) }

    before(:each) do
      allow(stdout).to receive(:puts)
      allow(aws_ec2_client).to receive(:create_image).and_return(create_image_response)
      allow(AwsHelpers::Actions::EC2::PollImageExists).to receive(:new).and_return(poll_image_exists)
      allow(poll_image_exists).to receive(:execute)
      allow(AwsHelpers::Actions::EC2::TagImage).to receive(:new).and_return(tag_image)
      allow(tag_image).to receive(:execute)
      allow(AwsHelpers::Actions::EC2::PollImageAvailable).to receive(:new).and_return(poll_image_available)
      allow(poll_image_available).to receive(:execute)
    end

    it 'should write to stdout that it is creating and image' do
      expect(stdout).to receive(:puts).with("Creating Image #{ami_name}")
      AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
    end

    it 'should call the aws_ec2_client create_image with correct parameters' do
      expect(aws_ec2_client).to receive(:create_image).with(instance_id: 'id', name: ami_name, description: ami_name)
      AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
    end

    it 'should call AwsHelpers::Actions::EC2::PollImageExists #new with correct parameters' do
      expect(AwsHelpers::Actions::EC2::PollImageExists).to receive(:new).with(config, image_id)
      AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::PollImageExists #execute' do
      expect(poll_image_exists).to receive(:execute)
      AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::TagImage #new with correct parameters' do
      expect(AwsHelpers::Actions::EC2::TagImage).to receive(:new).with(config, image_id, ami_name, now, [])
      AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
    end

    it 'should call AwsHelpers::Actions::EC2::TagImage #new with additional tags when optionally set' do
      additional_tags = [{ key: 'key', value: 'value' }]
      expect(AwsHelpers::Actions::EC2::TagImage).to receive(:new).with(config, image_id, ami_name, now, additional_tags)
      AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now, additional_tags: additional_tags).execute
    end

    it 'should call AwsHelpers::Actions::EC2::TagImage #execute' do
      expect(tag_image).to receive(:execute)
      AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::PollImageAvailable #new with correct parameters' do
      expect(AwsHelpers::Actions::EC2::PollImageAvailable).to receive(:new).with(config, image_id)
      AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::PollImageAvailable #execute' do
      expect(poll_image_available).to receive(:execute)
      AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
    end

  end

end
