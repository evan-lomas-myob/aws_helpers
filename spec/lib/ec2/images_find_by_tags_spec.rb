require 'rspec'
require 'aws_helpers/ec2'
require 'aws_helpers/ec2_actions/images_find_by_tags'

describe AwsHelpers::EC2Actions::ImagesFindByTags do

  let(:tags) { %w('tag1','tag2') }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_ec2_client: double) }
  let(:images_find_by_tags) { double(AwsHelpers::EC2Actions::ImagesFindByTags) }

  it '#images_find_by_tags' do
    allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::EC2Actions::ImagesFindByTags).to receive(:new).with(config, tags).and_return(images_find_by_tags)
    expect(images_find_by_tags).to receive(:execute)
    AwsHelpers::EC2.new(options).images_find_by_tags(tags: tags)
  end

end
