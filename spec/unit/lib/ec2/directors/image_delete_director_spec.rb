
describe AwsHelpers::EC2Commands::Directors::ImageDeleteDirector do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:director) { ImageDeleteDirector.new(config) }
  let(:request) { ImageDeleteRequest.new }

  [AwsHelpers::EC2Commands::Commands::ImageDeleteCommand,
   AwsHelpers::EC2Commands::Commands::PollImageDeletedCommand,
   AwsHelpers::EC2Commands::Commands::SnapshotsDeleteCommand].each do |klass|
    let(:command) { instance_double(klass) }
    before do
      allow(klass).to receive(:new).and_return(command)
      allow(command).to receive(:execute)
    end

    it 'creates the command' do
      expect(klass).to receive(:new).with(config, request)
      director.delete(request)
    end

    it 'calls execute on the command' do
      expect(command).to receive(:execute)
      director.delete(request)
    end
  end
end
