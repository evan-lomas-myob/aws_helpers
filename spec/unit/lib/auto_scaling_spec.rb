require 'aws_helpers/auto_scaling'

describe AwsHelpers::AutoScaling do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:auto_scaling_group_name) { 'my_group_name' }
  let(:config) { double(AwsHelpers::Config) }
  let(:desired_capacity) { 1 }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::AutoScaling.new(options)
    end

  end

  describe '#retrieve_desired_capacity' do

    let(:retrieve_desired_capacity) { double(RetrieveDesiredCapacity) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(RetrieveDesiredCapacity).to receive(:new).with(anything, anything).and_return(retrieve_desired_capacity)
      allow(retrieve_desired_capacity).to receive(:execute).and_return(desired_capacity)
    end

    subject { AwsHelpers::AutoScaling.new(options).retrieve_desired_capacity(auto_scaling_group_name: auto_scaling_group_name) }

    it 'should create RetrieveDesiredCapacity with correct parameters' do
      expect(RetrieveDesiredCapacity).to receive(:new).with(config, auto_scaling_group_name)
      subject
    end

    it 'should call RetrieveDesiredCapacity execute method' do
      expect(retrieve_desired_capacity).to receive(:execute)
      subject
    end

    it 'should return the desired capacity value as an Integer' do
      expect(retrieve_desired_capacity.execute).to eq(1)
    end

  end

  describe '#update_desired_capacity' do

    let(:update_desired_capacity) { double(UpdateDesiredCapacity) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(UpdateDesiredCapacity).to receive(:new).and_return(update_desired_capacity)
      allow(update_desired_capacity).to receive(:execute)
    end

    subject { AwsHelpers::AutoScaling.new(options).update_desired_capacity(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity) }

    it 'should call UpdateDesiredCapacity with correct parameters' do
      expect(UpdateDesiredCapacity).to receive(:new).with(config, auto_scaling_group_name, desired_capacity)
      subject
    end

    it 'should call UpdateDesiredCapacity #execute method' do
      expect(update_desired_capacity).to receive(:execute)
      subject
    end

  end

end