require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/images_find_by_tags'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe ImagesFindByTags do

  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:tags) { [{ name: 'Name', value: 'value' }] }
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

  it 'should call Aws::EC2::Client #describe_images with correct parameters' do
    expect(ec2_client).to receive(:describe_images).with(filters: [{ name: 'tag:Name', values: ['value'] }])
    ImagesFindByTags.new(config, tags).execute
  end

  it 'should return a list of images' do
    expect(ImagesFindByTags.new(config, tags).execute).to eql(images)
  end


end
