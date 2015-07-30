require 'rspec'
require 'aws_helpers/auto_scaling/client'
require 'aws_helpers/auto_scaling/retrieve_desired_capacity'

describe AwsHelpers::AutoScaling::RetrieveDesiredCapacity do

  let(:auto_scaling_group_name) { 'my_group_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_auto_scaling_client: double, aws_elastic_load_balancing_client: double) }

  let(:the_desired_capacity) { double(AwsHelpers::AutoScaling::RetrieveDesiredCapacity) }

  it 'should create AutoScalingGroup::RetrieveDesiredCapacity with an Aws::AutoScaling::Client' do

    allow(AwsHelpers::AutoScaling::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::AutoScaling::RetrieveDesiredCapacity).to receive(:new).with(config, auto_scaling_group_name).and_return(the_desired_capacity)
    expect(the_desired_capacity).to receive(:execute)
    AwsHelpers::AutoScaling::Client.new(options).retrieve_desired_capacity(auto_scaling_group_name)
  end

end