
describe AwsHelpers::EC2Commands::Directors::InstanceCreateDirector do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:director) { InstanceCreateDirector.new(config) }
  let(:request) { InstanceCreateRequest.new }

  [AwsHelpers::EC2Commands::Commands::InstanceCreateCommand,
   AwsHelpers::EC2Commands::Commands::PollInstanceAvailableCommand,
   AwsHelpers::EC2Commands::Commands::InstanceTagCommand,
   AwsHelpers::EC2Commands::Commands::PollInstanceHealthyCommand].each do |klass|
    let(:command) { instance_double(klass) }
    before do
      allow(klass).to receive(:new).and_return(command)
      allow(command).to receive(:execute)
    end

    it 'creates the command' do
      expect(klass).to receive(:new).with(config, request)
      director.create(request)
    end

    it 'calls execute on the command' do
      expect(command).to receive(:execute)
      director.create(request)
    end
  end
end
