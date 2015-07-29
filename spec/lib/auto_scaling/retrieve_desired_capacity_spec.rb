require 'rspec'
require 'aws_helpers/auto_scaling/client'
require 'aws_helpers/auto_scaling/retrieve_desired_capacity'

describe AwsHelpers::AutoScaling::RetrieveDesiredCapacity do

  let(:group_name) { 'my_group_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
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
