require 'aws_helpers/ec2_commands/commands/poll_instance_stopped_command'
require 'aws_helpers/ec2_commands/requests/poll_instance_stopped_request'

describe AwsHelpers::EC2Commands::Commands::PollInstanceStoppedCommand do
  let(:instance_id) { '123' }
  let(:instance) { Aws::EC2::Types::Instance.new(instance_id: instance_id)}
  let(:reservation) { Aws::EC2::Types::Reservation.new(instances: [instance]) }
  let(:instances) { Aws::EC2::Types::DescribeInstancesResult.new(reservations: [reservation]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::PollInstanceStoppedRequest.new }
  let(:running_state) { Aws::EC2::Types::InstanceState.new(name: 'running') }
  let(:stopped_state) { Aws::EC2::Types::InstanceState.new(name: 'stopped') }

  before do
    request.instance_polling = { delay: 0, max_attempts: 5 }
    request.instance_id = instance_id
    @command = AwsHelpers::EC2Commands::Commands::PollInstanceStoppedCommand.new(config, request)
    allow(ec2_client)
      .to receive(:describe_instances)
      .with(instance_ids: [instance_id])
      .and_return(instances)
  end

  it 'polls' do
    instance.state = stopped_state
    expect(@command).to receive(:poll)
    @command.execute
  end

  it 'returns if the instance state is stopped' do
    instance.state = stopped_state
    expect { @command.execute }.not_to raise_error
  end

  it 'times out and raises an exception if the instance state is anything else' do
    instance.state = running_state
    expect(ec2_client).to receive(:describe_instances).exactly(5).times
    expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
  end
end
