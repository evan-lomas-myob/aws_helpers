require 'aws_helpers/auto_scaling'

describe AwsHelpers::AutoScaling do
  let(:auto_scaling_group_name) { 'my_group_name' }
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:desired_capacity) { 1 }

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::AutoScaling.new(options)
    end
  end

  describe '#retrieve_desired_capacity' do
    let(:retrieve_desired_capacity) { instance_double(RetrieveDesiredCapacity) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(RetrieveDesiredCapacity).to receive(:new).and_return(retrieve_desired_capacity)
      allow(retrieve_desired_capacity).to receive(:execute).and_return(desired_capacity)
    end

    subject { AwsHelpers::AutoScaling.new.retrieve_desired_capacity(auto_scaling_group_name) }

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
    let(:update_desired_capacity) { instance_double(UpdateDesiredCapacity) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(UpdateDesiredCapacity).to receive(:new).and_return(update_desired_capacity)
      allow(update_desired_capacity).to receive(:execute)
    end

    subject { AwsHelpers::AutoScaling.new }

    it 'should call UpdateDesiredCapacity with all optional parameters' do
      update_desired_capacity_options = {
        stdout: $stdout,
        auto_scaling_pooling: {
          max_attempts: 1,
          delay: 2
        },
        load_balancer_pooling: {
          max_attempts: 3,
          delay: 4
        }
      }
      expect(UpdateDesiredCapacity)
        .to receive(:new).with(
          config,
          auto_scaling_group_name,
          desired_capacity,
          update_desired_capacity_options)
      subject.update_desired_capacity(
        auto_scaling_group_name,
        desired_capacity,
        update_desired_capacity_options
      )
    end

    it 'should call UpdateDesiredCapacity with minimum parameters' do
      expect(UpdateDesiredCapacity)
        .to receive(:new).with(config, auto_scaling_group_name, desired_capacity, {})
      subject.update_desired_capacity(
        auto_scaling_group_name,
        desired_capacity
      )
    end

    it 'should call UpdateDesiredCapacity #execute method' do
      expect(update_desired_capacity).to receive(:execute)
      subject.update_desired_capacity(
        auto_scaling_group_name,
        desired_capacity
      )
    end
  end

  describe '#retrieve_current_instances' do
    let(:retrieve_current_instances) { instance_double(RetrieveCurrentInstances) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(RetrieveCurrentInstances).to receive(:new).and_return(retrieve_current_instances)
      allow(retrieve_current_instances).to receive(:execute)
    end

    subject { AwsHelpers::AutoScaling.new.retrieve_current_instances(auto_scaling_group_name) }

    it 'should create RetrieveCurrentInstances with correct parameters' do
      expect(RetrieveCurrentInstances).to receive(:new).with(config, auto_scaling_group_name)
      subject
    end

    it 'should call RetrieveCurrentInstances execute method' do
      expect(retrieve_current_instances).to receive(:execute)
      subject
    end

    it 'should return nil' do
      expect(retrieve_current_instances.execute).to eq(nil)
    end
  end
end
