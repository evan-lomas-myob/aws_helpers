require 'aws_helpers/ec2_commands/commands/image_tag_command'
require 'aws_helpers/ec2_commands/requests/image_tag_request'

describe AwsHelpers::EC2Commands::Commands::ImageTagCommand do
  let(:image_id) { '123' }
  let(:tags) { %w(Batman, Robin) }
  let(:result) { Aws::EC2::Types::Reservation.new(instances: [instance]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::ImageTagRequest.new }

  before do
    request.image_id = image_id
    request.tags = tags
    @command = AwsHelpers::EC2Commands::Commands::ImageTagCommand.new(config, request)
    allow(ec2_client)
      .to receive(:create_tags)
  end

  it 'calls create_tags on the client with the correct parameters' do
    expect(ec2_client)
      .to receive(:create_tags)
      .with(resources: [image_id], tags: tags)
    @command.execute
  end
end
