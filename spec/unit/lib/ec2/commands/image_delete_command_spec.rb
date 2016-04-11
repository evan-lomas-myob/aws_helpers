require 'aws_helpers/ec2_commands/commands/image_delete_command'
require 'aws_helpers/ec2_commands/requests/image_delete_request'

describe AwsHelpers::EC2Commands::Commands::ImageDeleteCommand do
  let(:image_id) { '123' }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::ImageDeleteRequest.new }

  before do
    request.image_id = image_id
    @command = AwsHelpers::EC2Commands::Commands::ImageDeleteCommand.new(config, request)
  end

  it 'calls deregister_image on the client with the specified image id' do
    expect(ec2_client)
      .to receive(:deregister_image)
      .with(image_id: image_id)
    @command.execute
  end
end
