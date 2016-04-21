
describe AwsHelpers::KMSCommands::Directors::GetKeyArnDirector do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:director) { GetKeyArnDirector.new(config) }
  let(:request) { GetKeyArnRequest.new }

  [AwsHelpers::KMSCommands::Commands::GetKeyArnCommand].each do |klass|
    let(:command) { instance_double(klass) }
    before do
      allow(klass).to receive(:new).and_return(command)
      allow(command).to receive(:execute)
    end

    it 'creates the command' do
      expect(klass).to receive(:new).with(config, request)
      director.get(request)
    end

    it 'calls execute on the command' do
      expect(command).to receive(:execute)
      director.get(request)
    end
  end
end
