require 'rspec'
require 'aws_helpers/ec2/client'
require 'aws_helpers/ec2/images_delete'

describe 'AwsHelpers::EC2::ImageDelete' do

  let(:name) { 'ec2_name' }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_ec2_client: double) }
  let(:images_delete) { double(AwsHelpers::EC2::ImagesDelete) }

  it '#images_delete with options' do
    allow(AwsHelpers::EC2::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::EC2::ImagesDelete).to receive(:new).with(config, name, options).and_return(images_delete)
    expect(images_delete).to receive(:execute)
    AwsHelpers::EC2::Client.new(options).images_delete(name, options)
  end

  it '#images_delete without options' do
    allow(AwsHelpers::EC2::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::EC2::ImagesDelete).to receive(:new).with(config, name, nil).and_return(images_delete)
    expect(images_delete).to receive(:execute)
    AwsHelpers::EC2::Client.new(options).images_delete(name)
  end

end
