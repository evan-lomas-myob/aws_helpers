require 'aws_helpers/ec2_commands/commands/instance_stop_command'
require 'aws_helpers/ec2_commands/requests/instance_stop_request'

describe AwsHelpers::EC2Commands::Commands::InstanceStopCommand do
  let(:instance_id) { '123' }
  # let(:image_id) { '321' }
  # let(:instance) { Aws::EC2::Types::Instance.new(instance_id: instance_id) }
  # let(:result) { Aws::EC2::Types::Reservation.new(instances: [instance]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::InstanceStopRequest.new }

  before do
    request.instance_id = instance_id
    @command = AwsHelpers::EC2Commands::Commands::InstanceStopCommand.new(config, request)
    # allow(ec2_client)
    #   .to receive(:run_instances)
    #   .and_return(result)
  end

  it 'calls stop_instances on the client with the instance_id' do
    expect(ec2_client)
      .to receive(:stop_instances)
      .with(instance_ids: [instance_id])
    @command.execute
  end
end
