require 'aws_helpers/ec2_commands/commands/get_image_id_command'
require 'aws_helpers/ec2_commands/requests/get_image_id_request'

describe AwsHelpers::EC2Commands::Commands::GetImageIdCommand do
  let(:image_name) { 'Gotham' }
  let(:image_id) { '123' }
  let(:image) { Aws::EC2::Types::Image.new(image_id: image_id) }
  let(:images) { Aws::EC2::Types::DescribeImagesResult.new(images: [image]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::GetImageIdRequest.new }

  before do
    request.image_name = image_name
    @command = AwsHelpers::EC2Commands::Commands::GetImageIdCommand.new(config, request)
    allow(ec2_client).to receive(:describe_images)
      .with(filters: [{ name: 'tag:Name', values: [image_name] }])
      .and_return(images)
  end

  it 'returns the image id' do
    @command.execute
    expect(request.image_id).to eq(image_id)
  end
end
