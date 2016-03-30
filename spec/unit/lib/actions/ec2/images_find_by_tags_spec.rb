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

  it 'should display a deprecation warning when called with an array' do
    expect { ImagesFindByTags.new(config, tags_array).execute }.to output("Deprecation warning: AWS::EC2#images_find_by_tags now accepts a hash instead of an array\n").to_stderr
  end

  it 'should call Aws::EC2::Client #describe_images with correct parameters when given a hash' do
    expected_filters = [
        { name: 'tag:Name', values: ['value'] },
        { name: 'tag:Multi', values: %w(a b) }
    ]
    expect(ec2_client).to receive(:describe_images).with(filters: expected_filters)
    ImagesFindByTags.new(config, tags_hash).execute
  end

  it 'should return a list of images' do
    expect(ImagesFindByTags.new(config, tags_hash).execute).to eql(images)
  end

  it 'should should raise an exception when tag format is wrong' do
    expect { ImagesFindByTags.new(config, 'string').execute }.to raise_error(ArgumentError)
  end
end
