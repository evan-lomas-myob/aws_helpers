require 'aws_helpers/ec2_commands/commands/image_create_command'
require 'aws_helpers/ec2_commands/requests/image_create_request'

describe AwsHelpers::EC2Commands::Commands::ImageCreateCommand do
  let(:instance_id) { '123' }
  let(:image_id) { '321' }
  let(:image_name) { 'Batman' }
  let(:result) { Aws::EC2::Types::CreateImageResult.new(image_id: image_id) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::ImageCreateRequest.new }

  before do
    request.instance_id = instance_id
    request.image_name = image_name
    @command = AwsHelpers::EC2Commands::Commands::ImageCreateCommand.new(config, request)
    allow(ec2_client)
      .to receive(:create_image)
      .and_return(result)
  end

  it 'calls create_image on the client with the correct parameters' do
    expect(ec2_client)
      .to receive(:create_image)
      .with(instance_id: instance_id, name: image_name, description: image_name)
    @command.execute
  end

  it 'adds the image_id to the request' do
    @command.execute
    expect(request.image_id).to eq(image_id)
  end
end
