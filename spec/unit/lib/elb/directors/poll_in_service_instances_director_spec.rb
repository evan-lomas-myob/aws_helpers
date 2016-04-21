
describe AwsHelpers::ELBCommands::Directors::PollInServiceInstancesDirector do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:director) { PollInServiceInstancesDirector.new(config) }
  let(:request) { PollInServiceInstancesRequest.new }

  [AwsHelpers::ELBCommands::Commands::PollInServiceInstancesCommand].each do |klass|
    let(:command) { instance_double(klass) }
    before do
      allow(klass).to receive(:new).and_return(command)
      allow(command).to receive(:execute)
    end

    it 'creates the command' do
      expect(klass).to receive(:new).with(config, request)
      director.execute(request)
    end

    it 'calls execute on the command' do
      expect(command).to receive(:execute)
      director.execute(request)
    end
  end
end
