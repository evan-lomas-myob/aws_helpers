require 'time'
require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/image_create'
require 'aws_helpers/actions/ec2/poll_image_exists'
require 'aws_helpers/actions/ec2/tag_image'
require 'aws_helpers/actions/ec2/poll_image_available'
require 'aws_helpers/actions/ec2/image_delete'

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
    let(:image_delete) { instance_double(AwsHelpers::Actions::EC2::ImageDelete) }

    before(:each) do
      allow(aws_ec2_client).to receive(:create_image).and_return(create_image_response)
      allow(stdout).to receive(:puts)
    end

    context 'without any exceptions from tagging or polling when the images are available' do

      before(:each) do
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
        expect(AwsHelpers::Actions::EC2::PollImageExists).to receive(:new).with(config, image_id, stdout: stdout)
        AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
      end

      it 'should call AwsHelpers::Actions::EC2::PollImageExists #execute' do
        expect(poll_image_exists).to receive(:execute)
        AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
      end

      it 'should call AwsHelpers::Actions::EC2::TagImage #new with correct parameters' do
        expect(AwsHelpers::Actions::EC2::TagImage).to receive(:new).with(config, image_id, name, now, additional_tags: [], stdout: stdout)
        AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
      end

      it 'should call AwsHelpers::Actions::EC2::TagImage #new with additional tags when optionally set' do
        additional_tags = [{ key: 'key', value: 'value' }]
        expect(AwsHelpers::Actions::EC2::TagImage).to receive(:new).with(config, image_id, name, now, additional_tags: additional_tags, stdout: stdout)
        AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now, additional_tags: additional_tags).execute
      end

      it 'should call AwsHelpers::Actions::EC2::TagImage #execute' do
        expect(tag_image).to receive(:execute)
        AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
      end

      it 'should call AwsHelpers::Actions::EC2::PollImageAvailable #new with correct parameters' do
        expect(AwsHelpers::Actions::EC2::PollImageAvailable).to receive(:new).with(config, image_id, stdout: stdout)
        AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
      end

      it 'should call AwsHelpers::Actions::EC2::PollImageAvailable #execute' do
        expect(poll_image_available).to receive(:execute)
        AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute
      end

      it 'should return the image_id' do
        expect(AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout).execute).to eql(image_id)
      end

    end

    context 'with an exception from AwsHelpers::Actions::EC2::PollImageExists #execute' do

      before(:each) do
        allow(AwsHelpers::Actions::EC2::PollImageExists).to receive(:new).and_return(poll_image_exists)
        allow(poll_image_exists).to receive(:execute).and_raise(StandardError.new('message'))
        allow(AwsHelpers::Actions::EC2::ImageDelete).to receive(:new).and_return(image_delete)
        allow(image_delete).to receive(:execute)
      end

      it 'should call AwsHelpers::Actions::EC2::ImageDelete #new with correct parameters' do
        expect(AwsHelpers::Actions::EC2::ImageDelete).to receive(:new).with(config, image_id, stdout: stdout)
        begin
          AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
        rescue
          # ignored
        end
      end

      it 'should call AwsHelpers::Actions::EC2::ImageDelete #execute' do
        expect(image_delete).to receive(:execute)
        begin
          AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
        rescue
          # ignored
        end

      end

      it 'should rethrow the Error' do
        expect { AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute }
          .to raise_error(StandardError, 'message')
      end

    end

    context 'with an exception from AwsHelpers::Actions::EC2::TagImage #execute' do

      before(:each) do
        allow(AwsHelpers::Actions::EC2::PollImageExists).to receive(:new).and_return(poll_image_exists)
        allow(poll_image_exists).to receive(:execute)
        allow(AwsHelpers::Actions::EC2::TagImage).to receive(:new).and_return(tag_image)
        allow(tag_image).to receive(:execute).and_raise(StandardError.new('message'))
        allow(AwsHelpers::Actions::EC2::ImageDelete).to receive(:new).and_return(image_delete)
        allow(image_delete).to receive(:execute)
      end

      it 'should call AwsHelpers::Actions::EC2::ImageDelete #new with correct parameters' do
        expect(AwsHelpers::Actions::EC2::ImageDelete).to receive(:new).with(config, image_id, stdout: stdout)
        begin
          AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
        rescue
          # ignored
        end
      end

      it 'should call AwsHelpers::Actions::EC2::ImageDelete #execute' do
        expect(image_delete).to receive(:execute)
        begin
          AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
        rescue
          # ignored
        end

      end

      it 'should rethrow the Error' do
        expect { AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute }
          .to raise_error(StandardError, 'message')
      end

    end

    context 'with an exception from AwsHelpers::Actions::EC2::PollImageAvailable #execute' do

      before(:each) do
        allow(AwsHelpers::Actions::EC2::PollImageExists).to receive(:new).and_return(poll_image_exists)
        allow(poll_image_exists).to receive(:execute)
        allow(AwsHelpers::Actions::EC2::TagImage).to receive(:new).and_return(tag_image)
        allow(tag_image).to receive(:execute)
        allow(AwsHelpers::Actions::EC2::PollImageAvailable).to receive(:new).and_return(poll_image_available)
        allow(poll_image_available).to receive(:execute).and_raise(StandardError.new('message'))
        allow(AwsHelpers::Actions::EC2::ImageDelete).to receive(:new).and_return(image_delete)
        allow(image_delete).to receive(:execute)
      end

      it 'should call AwsHelpers::Actions::EC2::ImageDelete #new with correct parameters' do
        expect(AwsHelpers::Actions::EC2::ImageDelete).to receive(:new).with(config, image_id, stdout: stdout)
        begin
          AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
        rescue
          # ignored
        end
      end

      it 'should call AwsHelpers::Actions::EC2::ImageDelete #execute' do
        expect(image_delete).to receive(:execute)
        begin
          AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute
        rescue
          # ignored
        end

      end

      it 'should rethrow the Error' do
        expect { AwsHelpers::Actions::EC2::ImageCreate.new(config, 'id', name, stdout: stdout, now: now).execute }
          .to raise_error(StandardError, 'message')
      end

    end

  end

end
