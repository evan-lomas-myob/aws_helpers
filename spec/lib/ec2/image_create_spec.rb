require 'rspec'
require 'aws_helpers/ec2'
require 'aws_helpers/ec2_actions/image_create'

describe 'AwsHelpers::EC2::ImageCreate' do

  let(:name) { 'ec2_name' }
  let(:instance_id) { 'ec2_id' }
  let(:additional_tags) { %w('tag1', 'tag2') }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_ec2_client: double) }
  let(:image_create) { double(AwsHelpers::EC2Actions::ImageCreate) }

  it '#image_create without additional tags' do
    allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::EC2Actions::ImageCreate).to receive(:new).with(config, name, instance_id, []).and_return(image_create)
    expect(image_create).to receive(:execute)
    AwsHelpers::EC2.new(options).image_create(name: name, instance_id: instance_id)
  end

  it '#image_create with additional tags' do
    allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::EC2Actions::ImageCreate).to receive(:new).with(config, name, instance_id, additional_tags).and_return(image_create)
    expect(image_create).to receive(:execute)
    AwsHelpers::EC2.new(options).image_create(name: name, instance_id: instance_id, additional_tags: additional_tags)
  end

end
