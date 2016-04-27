require 'aws_helpers/ec2_commands/commands/instance_tag_command'
require 'aws_helpers/ec2_commands/requests/instance_tag_request'

describe AwsHelpers::EC2Commands::Commands::InstanceTagCommand do
  let(:instance_id) { '123' }
  let(:tags) { %w(Batman, Robin) }
  let(:instance) { Aws::EC2::Types::Instance.new(instance_id: instance_id) }
  let(:result) { Aws::EC2::Types::Reservation.new(instances: [instance]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::InstanceTagRequest.new }

  before do
    request.instance_id = instance_id
    request.tags = tags
    @command = AwsHelpers::EC2Commands::Commands::InstanceTagCommand.new(config, request)
    allow(ec2_client)
      .to receive(:create_tags)
      .and_return(result)
  end

  it 'calls create_tags on the client with the correct parameters' do
    expect(ec2_client)
      .to receive(:create_tags)
      .with(resources: [instance_id], tags: tags)
    @command.execute
  end
end
