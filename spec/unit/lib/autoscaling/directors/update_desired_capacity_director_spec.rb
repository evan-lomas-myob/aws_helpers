
describe AwsHelpers::AutoScalingCommands::Directors::UpdateDesiredCapacityDirector do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:director) { UpdateDesiredCapacityDirector.new(config) }
  let(:request) { UpdateDesiredCapacityRequest.new }

  [AwsHelpers::AutoScalingCommands::Commands::UpdateDesiredCapacityCommand].each do |klass|
    let(:command) { instance_double(klass) }
    before do
      allow(klass).to receive(:new).and_return(command)
      allow(command).to receive(:execute)
    end

    it 'creates the command' do
      expect(klass).to receive(:new).with(config, request)
      director.update(request)
    end

    it 'calls execute on the command' do
      expect(command).to receive(:execute)
      director.update(request)
    end
  end
end
