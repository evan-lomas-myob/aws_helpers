
describe AwsHelpers::NATCommands::Directors::GatewayDeleteDirector do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:director) { GatewayDeleteDirector.new(config) }
  let(:request) { GatewayDeleteRequest.new }

  [AwsHelpers::NATCommands::Commands::GatewayDeleteCommand].each do |klass|
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
