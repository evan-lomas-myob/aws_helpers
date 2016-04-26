
describe AwsHelpers::EC2Commands::Directors::ImageCreateDirector do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:director) { ImageCreateDirector.new(config) }
  let(:request) { ImageCreateRequest.new }

  [AwsHelpers::EC2Commands::Commands::ImageConstructNameCommand,
   AwsHelpers::EC2Commands::Commands::ImageCreateCommand,
   AwsHelpers::EC2Commands::Commands::PollImageAvailableCommand].each do |klass|
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
