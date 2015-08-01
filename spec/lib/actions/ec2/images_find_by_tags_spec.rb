require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/images_find_by_tags'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe ImagesFindByTags do

  let(:tags) { %w('tag1','tag2') }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_ec2_client: double) }
  let(:images_find_by_tags) { double(ImagesFindByTags) }

  it '#images_find_by_tags' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(ImagesFindByTags).to receive(:new).with(config, tags).and_return(images_find_by_tags)
    expect(images_find_by_tags).to receive(:execute)
    EC2.new(options).images_find_by_tags(tags: tags)
  end

end
