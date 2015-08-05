require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/images_find_by_tag'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe ImagesFindByTag do

  let(:ec2_client) { double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }

  let(:image_id) { 'image_id' }
  let(:images) { [ double( image_id: image_id ) ]}

  let(:filter) { double(:filters, name: 'name', values: [ 'a_value', 'another_value' ] ) }

  it 'should return an array of Images by filtering tags' do
    allow(ec2_client).to receive(:describe_images).with(filter).and_return(images)
    expect(ImagesFindByTag.new(config, filter).execute).to be(images)
  end

end
