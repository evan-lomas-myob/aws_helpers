require 'rspec'
require 'aws_helpers/ec2/client'
require 'aws_helpers/ec2/image_create'

describe 'AwsHelpers::EC2::ImageCreate' do

  let(:name) { 'ec2_name' }
  let(:instance_id) { 'ec2_id' }
  let(:additional_tags) { %w('tag1', 'tag2') }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_ec2_client: double) }
  let(:image_create) { double(AwsHelpers::EC2::ImageCreate) }

  it '#image_create without additional tags' do
    allow(AwsHelpers::EC2::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::EC2::ImageCreate).to receive(:new).with(config, instance_id, name, []).and_return(image_create)
    expect(image_create).to receive(:execute)
    AwsHelpers::EC2::Client.new(options).image_create(instance_id, name)
  end

  it '#image_create with additional tags' do
    allow(AwsHelpers::EC2::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::EC2::ImageCreate).to receive(:new).with(config, instance_id, name, additional_tags).and_return(image_create)
    expect(image_create).to receive(:execute)
    AwsHelpers::EC2::Client.new(options).image_create(instance_id, name, additional_tags)
  end

end
