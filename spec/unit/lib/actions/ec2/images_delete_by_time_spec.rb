require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/images_delete_by_time'
require 'aws_helpers/actions/ec2/images_find_by_tags'
require 'aws_helpers/actions/ec2/image_delete'

describe AwsHelpers::Actions::EC2::ImagesDeleteByTime do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:now) { Time.now }
    let(:name) { 'name' }
    let(:images_find_by_tags) { instance_double(AwsHelpers::Actions::EC2::ImagesFindByTags) }
    let(:image_id) { 'image_id' }
    let(:images_delete) { instance_double(AwsHelpers::Actions::EC2::ImagesDelete) }
    let(:date_tag) { instance_double(Aws::EC2::Types::Tag, key: 'Name', value: 'Jenkins Slave Image') }
    let(:name_tag) { instance_double(Aws::EC2::Types::Tag, key: 'Date', value: '2015-12-16 11:57:42 +1100') }
    let(:tags) { [ date_tag, name_tag ] }

    before(:each) do
      allow(stdout).to receive(:puts)
      allow(AwsHelpers::Actions::EC2::ImagesFindByTags).to receive(:new).and_return(images_find_by_tags)
      allow(images_find_by_tags)
        .to receive(:execute)
              .and_return([instance_double(Aws::EC2::Types::Image, image_id: image_id, tags: tags)])
      allow(AwsHelpers::Actions::EC2::ImageDelete).to receive(:new).and_return(images_delete)
      allow(images_delete).to receive(:execute)
    end

    it 'should call stdout with details of what is to be deleted' do
      expect(stdout).to receive(:puts).with("Deleting images tagged with Name:#{name} created before #{now}")
      AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(config, name, now, stdout: stdout).execute
    end

    it 'should call ImagesFindByTags #new with correct parameters' do
      expect(AwsHelpers::Actions::EC2::ImagesFindByTags).to receive(:new).with(config, [{ name: 'Name', value: name }])
      AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(config, name, now, stdout: stdout).execute
    end

    it 'should call ImagesFindByTags #execute' do
      expect(images_find_by_tags).to receive(:execute)
      AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(config, name, now, stdout: stdout).execute
    end

    it 'should call ImageDelete #new with correct parameters' do
      expect(AwsHelpers::Actions::EC2::ImageDelete).to receive(:new).with(config, image_id, stdout: stdout)
      AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(config, name, now, stdout: stdout).execute
    end

    it 'should call ImageDelete #execute' do
      expect(images_delete).to receive(:execute)
      AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(config, name, now, stdout: stdout).execute
    end

  end

end
