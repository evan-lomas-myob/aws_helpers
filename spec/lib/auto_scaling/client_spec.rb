require 'rspec'
require 'aws_helpers/auto_scaling/client'
require 'aws_helpers/auto_scaling/retrieve_desired_capacity'
require 'aws_helpers/auto_scaling/update_desired_capacity'

describe AwsHelpers::AutoScaling::Client do

  let(:group_name) { 'my_group_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::AutoScaling::Client).to receive(:new).with(options).and_return(AwsHelpers::AutoScaling::Config)
      AwsHelpers::AutoScaling::Client.new(options)
    end

  end

  describe '#retrieve_desired_capacity' do

    let(:the_desired_capacity) { double(AwsHelpers::AutoScaling::RetrieveDesiredCapacity) }

    after(:each) do
      AwsHelpers::AutoScaling::Client.new(options).retrieve_desired_capacity(group_name)
    end

    it 'should create AutoScalingGroup::RetrieveDesiredCapacity with an Aws::AutoScaling::Client' do
      allow(the_desired_capacity).to receive(:execute)
      expect(AwsHelpers::AutoScaling::RetrieveDesiredCapacity).to receive(:new).with(be_an_instance_of(Aws::AutoScaling::Client), anything).and_return(the_desired_capacity)
    end

    it 'should create AutoScalingGroup::RetrieveDesiredCapacity passing the correct auto_scaling_group_name' do
      allow(the_desired_capacity).to receive(:execute)
      expect(AwsHelpers::AutoScaling::RetrieveDesiredCapacity).to receive(:new).with(anything, group_name).and_return(the_desired_capacity)
    end

    it 'should call AutoScalingGroup::RetrieveDesiredCapacity execute method' do
      allow(AwsHelpers::AutoScaling::RetrieveDesiredCapacity).to receive(:new).with(anything, anything).and_return(the_desired_capacity)
      expect(the_desired_capacity).to receive(:execute)
    end

  end

  describe '#update_desired_capacity' do

    let(:update_desired_capacity) { double(AwsHelpers::AutoScaling::UpdateDesiredCapacity) }
    let(:auto_scaling_client) { double(Aws::AutoScaling::Client) }
    let(:elastic_loadbalancing_client) { double(Aws::ElasticLoadBalancing::Client) }

    let(:desired_capacity) { 1 }
    let(:timeout) { 1 }

    after(:each) do
      AwsHelpers::AutoScaling::Client.new(options).update_desired_capacity(group_name, desired_capacity, timeout)
    end

    it 'should pass options to the Aws::AutoScaling::Client' do
      expect(Aws::AutoScaling::Client).to receive(:new).with(hash_including(options)).and_return(auto_scaling_client)
    end

    it 'should pass options to the Aws::ElasticLoadBalancing::Client' do
      expect(Aws::ElasticLoadBalancing::Client).to receive(:new).with(hash_including(options)).and_return(elastic_loadbalancing_client)
    end

    it 'should create AutoScalingGroup::UpdateDesiredCapacity passing the correct auto_scaling_group_name, desired capacity and timeout' do
      allow(update_desired_capacity).to receive(:execute)
      expect(AwsHelpers::AutoScaling::UpdateDesiredCapacity).to receive(:new).with(be_an_instance_of(Aws::AutoScaling::Client), be_an_instance_of(Aws::ElasticLoadBalancing::Client), group_name, desired_capacity, timeout).and_return(update_desired_capacity)

    end

    it 'should call AutoScalingGroup::UpdateDesiredCapacity execute method' do
      allow(AwsHelpers::AutoScaling::UpdateDesiredCapacity).to receive(:new).with(be_an_instance_of(Aws::AutoScaling::Client), be_an_instance_of(Aws::ElasticLoadBalancing::Client), group_name, desired_capacity, timeout).and_return(update_desired_capacity)
      expect(update_desired_capacity).to receive(:execute)
    end

  end

end