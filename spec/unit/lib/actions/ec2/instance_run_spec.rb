require 'aws_helpers'
require 'aws_helpers/actions/ec2/instance_run'

include AwsHelpers::Actions::EC2

describe EC2InstanceRun do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
  let(:stdout) { instance_double(IO) }

  let(:image_id) { 'ami-image-id' }
  let(:min_count) { 1 }
  let(:max_count) { 1 }
  let(:monitoring) { true }
  let(:monitoring_disabled) { false }

  let(:default_instance_type) { 't2.micro' }
  let(:larger_instance_type) { 'c4.large' }

  let(:options_with_instance) { {instance_type: larger_instance_type, stdout: stdout} }
  let(:options_with_stdout) { {stdout: stdout} }

  let(:instance_id) { 'my-instance-id' }
  let(:instances) { [instance_double(Aws::EC2::Types::Instance, instance_id: instance_id)] }
  let(:reservation) { instance_double(Aws::EC2::Types::Reservation, instances: instances) }

  before(:each) do
    allow(aws_ec2_client).to receive(:run_instances)
                                 .with(image_id: image_id,
                                       min_count: min_count,
                                       max_count: max_count,
                                       instance_type: default_instance_type,
                                       monitoring: {enabled: monitoring} )
                                 .and_return(reservation)
    allow(stdout).to receive(:puts).and_return("Starting Instance with #{image_id}")
  end
  it 'should output a message saying it is starting an instance' do
    expect(stdout).to receive(:puts).and_return("Starting Instance with #{image_id}")
    EC2InstanceRun.new(config, image_id, min_count, max_count, monitoring, options_with_stdout).execute
  end

  it 'should call run_instances to start the new AWS EC2 instances' do
    expect(aws_ec2_client).to receive(:run_instances)
                                  .with(image_id: image_id,
                                        min_count: min_count,
                                        max_count: max_count,
                                        instance_type: default_instance_type,
                                        monitoring: {enabled: monitoring} )
                                  .and_return(reservation)
    EC2InstanceRun.new(config, image_id, min_count, max_count, monitoring, options_with_stdout).execute
  end

  it 'should return the instance_id' do
    expect(EC2InstanceRun.new(config, image_id, min_count, max_count, monitoring, options_with_stdout).execute).to eq(instance_id)
  end

  it 'should call run_instances with a different instance type' do
    expect(aws_ec2_client).to receive(:run_instances)
                                  .with(image_id: image_id,
                                        min_count: min_count,
                                        max_count: max_count,
                                        instance_type: larger_instance_type,
                                        monitoring: {enabled: monitoring} )
                                  .and_return(reservation)
    EC2InstanceRun.new(config, image_id, min_count, max_count, monitoring, options_with_instance).execute
  end

end