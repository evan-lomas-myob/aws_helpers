require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/images_find_by_tags'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe ImagesFindByTags do

  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:tags_array) { [{ name: 'Name', value: 'value' }] }
  let(:tags_hash) { { 'Name' => 'value', 'Multi' => ['a', 'b'] } }
  let(:images) { [instance_double(Aws::EC2::Types::Image)] }

  before(:each) do
    allow(ec2_client)
      .to receive(:describe_images)
            .and_return(
              instance_double(
                Aws::EC2::Types::DescribeImagesResult,
                images: images
              )
            )
  end

  it 'should call Aws::EC2::Client #describe_images with correct parameters when given an array' do
    expect(ec2_client).to receive(:describe_images).with(filters: [{ name: 'tag:Name', values: ['value'] }])
    ImagesFindByTags.new(config, tags_array).execute
  end

  it 'should call Aws::EC2::Client #describe_images with correct parameters when given a hash' do
    expected_filters = [
      { name: 'tag:Name', values: ['value'] },
      { name: 'tag:Multi', values: ['a', 'b'] },
    ]
    expect(ec2_client).to receive(:describe_images).with(filters: expected_filters)
    ImagesFindByTags.new(config, tags_hash).execute
  end

  it 'should return a list of images' do
    expect(ImagesFindByTags.new(config, tags_array).execute).to eql(images)
  end


end
