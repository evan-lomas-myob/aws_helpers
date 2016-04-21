require 'aws_helpers/auto_scaling'

describe AwsHelpers::AutoScaling do
  let(:desired_capacity) { 42 }
  let(:auto_scaling_group_name) { 'my_group_name' }
  let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }
  let(:desired_capacity) { 1 }

  before do
    allow(AwsHelpers::Config).to receive(:new).and_return(config)
  end

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::AutoScaling.new(options)
    end
  end

  describe '#retrieve_desired_capacity' do

    let(:request) { GetDesiredCapacityRequest.new(auto_scaling_group_name: auto_scaling_group_name) }
    let(:director) { instance_double(GetDesiredCapacityDirector) }

    before(:each) do
      allow(GetDesiredCapacityRequest).to receive(:new).and_return(request)
      allow(GetDesiredCapacityDirector).to receive(:new).and_return(director)
      allow(director).to receive(:get).and_return(desired_capacity)
    end

    it 'should create a GetDesiredCapacityRequest' do
      expect(GetDesiredCapacityRequest)
        .to receive(:new)
        .with(auto_scaling_group_name: auto_scaling_group_name)
      AwsHelpers::AutoScaling.new.retrieve_desired_capacity(auto_scaling_group_name)
    end

    it 'should create a GetDesiredCapacityDirector' do
      expect(GetDesiredCapacityDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::AutoScaling.new.retrieve_desired_capacity(auto_scaling_group_name)
    end

    it 'should call get on the director' do
      expect(director)
        .to receive(:get)
        .with(request)
      AwsHelpers::AutoScaling.new.retrieve_desired_capacity(auto_scaling_group_name)
    end

    it 'return the desired_capacity' do
      capacity = AwsHelpers::AutoScaling.new.retrieve_desired_capacity(auto_scaling_group_name)
      expect(capacity).to eq(desired_capacity)
    end
  end

  describe '#update_desired_capacity' do
    let(:request) { UpdateDesiredCapacityRequest.new(auto_scaling_group_name: auto_scaling_group_name) }
    let(:director) { instance_double(UpdateDesiredCapacityDirector) }

    before(:each) do
      # allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(UpdateDesiredCapacityRequest).to receive(:new).and_return(request)
      allow(UpdateDesiredCapacityDirector).to receive(:new).and_return(director)
      allow(director).to receive(:update).and_return(desired_capacity)
    end

    it 'should create a UpdateDesiredCapacityRequest' do
      expect(UpdateDesiredCapacityRequest)
        .to receive(:new)
        .with(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity)
      AwsHelpers::AutoScaling.new.update_desired_capacity(auto_scaling_group_name, desired_capacity)
    end

    # subject { AwsHelpers::AutoScaling.new }

    # it 'should call UpdateDesiredCapacity with all optional parameters' do
    #   update_desired_capacity_options = {
    #     stdout: $stdout,
    #     auto_scaling_pooling: {
    #       max_attempts: 1,
    #       delay: 2
    #     },
    #     load_balancer_pooling: {
    #       max_attempts: 3,
    #       delay: 4
    #     }
    #   }
    #   expect(UpdateDesiredCapacity)
    #     .to receive(:new).with(
    #       config,
    #       auto_scaling_group_name,
    #       desired_capacity,
    #       update_desired_capacity_options)
    #   subject.update_desired_capacity(
    #     auto_scaling_group_name,
    #     desired_capacity,
    #     update_desired_capacity_options
    #   )
    # end

    # it 'should call UpdateDesiredCapacity with minimum parameters' do
    #   expect(UpdateDesiredCapacity)
    #     .to receive(:new).with(config, auto_scaling_group_name, desired_capacity, {})
    #   subject.update_desired_capacity(
    #     auto_scaling_group_name,
    #     desired_capacity
    #   )
    # end

    # it 'should call UpdateDesiredCapacity #execute method' do
    #   expect(update_desired_capacity).to receive(:execute)
    #   subject.update_desired_capacity(
    #     auto_scaling_group_name,
    #     desired_capacity
    #   )
    # end
  end

  describe '#retrieve_current_instances' do
  #   let(:retrieve_current_instances) { instance_double(RetrieveCurrentInstances) }

  #   before(:each) do
  #     allow(AwsHelpers::Config).to receive(:new).and_return(config)
  #     allow(RetrieveCurrentInstances).to receive(:new).and_return(retrieve_current_instances)
  #     allow(retrieve_current_instances).to receive(:execute)
  #   end

  #   subject { AwsHelpers::AutoScaling.new.retrieve_current_instances(auto_scaling_group_name) }

  #   it 'should create RetrieveCurrentInstances with correct parameters' do
  #     expect(RetrieveCurrentInstances).to receive(:new).with(config, auto_scaling_group_name)
  #     subject
  #   end

  #   it 'should call RetrieveCurrentInstances execute method' do
  #     expect(retrieve_current_instances).to receive(:execute)
  #     subject
  #   end

  #   it 'should return nil' do
  #     expect(retrieve_current_instances.execute).to eq(nil)
  #   end
  end
end
