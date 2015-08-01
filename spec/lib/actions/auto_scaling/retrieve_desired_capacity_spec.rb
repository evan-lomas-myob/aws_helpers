require 'aws_helpers/auto_scaling'
require 'aws_helpers/actions/auto_scaling/retrieve_desired_capacity'

include AwsHelpers
include AwsHelpers::Actions::AutoScaling

describe RetrieveDesiredCapacity do

  let(:auto_scaling_group_name) { 'my_group_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_auto_scaling_client: double, aws_elastic_load_balancing_client: double) }
  let(:the_desired_capacity) { double(RetrieveDesiredCapacity) }

  it 'should create AutoScalingGroup::RetrieveDesiredCapacity with an Aws::AutoScaling::Client' do

    allow(Config).to receive(:new).with(options).and_return(config)
    allow(RetrieveDesiredCapacity).to receive(:new).with(config, auto_scaling_group_name).and_return(the_desired_capacity)
    expect(the_desired_capacity).to receive(:execute)
    AutoScaling.new(options).retrieve_desired_capacity(auto_scaling_group_name: auto_scaling_group_name)
  end

end