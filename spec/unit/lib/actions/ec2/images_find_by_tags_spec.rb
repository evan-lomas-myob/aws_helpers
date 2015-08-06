require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/images_find_by_tags'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe ImagesFindByTags do

  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }

  let(:images) { %w('image1', 'image2') }
  let(:tags) { [ { name: 'Name', values: %w('tag1', 'tag2') } ] }

  it 'should find the images using a tags array as a filter' do
    allow(ec2_client).to receive(:describe_images).with(tags).and_return(images)
    expect(ImagesFindByTags.new(config, tags).execute).to be(images)
  end

end
