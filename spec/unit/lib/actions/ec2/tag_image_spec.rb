require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/tag_image'
require 'aws_helpers/actions/ec2/tag_resource'


describe AwsHelpers::Actions::EC2::TagImage do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:tag_resource) { instance_double(AwsHelpers::Actions::EC2::TagResource) }
    let(:image_id) { 'image_id' }
    let(:image_name) { 'image_name' }
    let(:now) { Time.now }
    let(:tags) {
      [
        { key: 'Name', value: image_name },
        { key: 'Date', value: now.to_s }
      ]
    }

    before(:each) do
      allow(stdout).to receive(:puts)
      allow(AwsHelpers::Actions::EC2::TagResource).to receive(:new).and_return(tag_resource)
      allow(tag_resource).to receive(:execute)
    end

    it 'should call stdout #puts with a description of the image being tagged' do
      expect(stdout).to receive(:puts).with("Tagging Image:#{image_id}")
      AwsHelpers::Actions::EC2::TagImage.new(config, image_id, image_name, now, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::TagResource #new with correct parameters' do
      expect(AwsHelpers::Actions::EC2::TagResource).to receive(:new).with(config, image_id, tags)
      AwsHelpers::Actions::EC2::TagImage.new(config, image_id, image_name, now, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::TagResource #new with correct parameters' do
      expect(tag_resource).to receive(:execute)
      AwsHelpers::Actions::EC2::TagImage.new(config, image_id, image_name, now, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Actions::EC2::TagResource #new with optional additional tags' do
      additional_tags = [{ key: 'key', value: 'value' }]
      expect(AwsHelpers::Actions::EC2::TagResource).to receive(:new).with(config, image_id, tags + additional_tags)
      AwsHelpers::Actions::EC2::TagImage.new(config, image_id, image_name, now, additional_tags: additional_tags).execute
    end

  end

end
