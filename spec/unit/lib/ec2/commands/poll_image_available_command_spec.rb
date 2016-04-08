require 'aws_helpers/ec2_commands/commands/poll_image_available_command'
require 'aws_helpers/ec2_commands/requests/image_create_request'

describe AwsHelpers::EC2Commands::Commands::PollImageAvailableCommand do
  let(:image) { Aws::EC2::Types::Image.new }
  let(:result) { Aws::EC2::Types::DescribeImagesResult.new(images: [image]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::ImageCreateRequest.new }

  before do
    @command = AwsHelpers::EC2Commands::Commands::PollImageAvailableCommand.new(config, request)
    allow(ec2_client)
      .to receive(:describe_images)
      .and_return(result)
  end

  it 'polls' do
    image.state = 'available'
    expect(@command).to receive(:poll)
    @command.execute
  end

  it 'returns if the image status is available' do
    image.state = 'available'
    expect { @command.execute }.not_to raise_error
  end

  it 'raises an exception if the image status is failed' do
    image.state = 'failed'
    request.image_name = 'Batman'
    expect { @command.execute }.to raise_error(RuntimeError)
  end
end
