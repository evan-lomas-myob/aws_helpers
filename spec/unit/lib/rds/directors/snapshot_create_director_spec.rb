
describe AwsHelpers::RDSCommands::Directors::SnapshotCreateDirector do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:director) { SnapshotCreateDirector.new(config) }
  let(:request) { SnapshotCreateRequest.new }

  [AwsHelpers::RDSCommands::Commands::PollInstanceAvailableCommand,
   AwsHelpers::RDSCommands::Commands::SnapshotConstructNameCommand,
   AwsHelpers::RDSCommands::Commands::SnapshotCreateCommand,
   AwsHelpers::RDSCommands::Commands::PollSnapshotAvailableCommand].each do |klass|
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
