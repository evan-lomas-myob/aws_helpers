require 'aws_helpers'
require 'aws_helpers/actions/ec2/instance_create'
require 'aws_helpers/actions/ec2/instance_run'
require 'aws_helpers/actions/ec2/poll_instance_exists'
require 'aws_helpers/actions/ec2/instance_tag'
require 'aws_helpers/actions/ec2/poll_instance_healthy'

include AwsHelpers::Actions::EC2

describe InstanceCreate do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
  let(:stdout) { instance_double(IO) }

  let(:ec2_instance_run) { instance_double(EC2InstanceRun) }
  let(:ec2_instance_tag) { instance_double(EC2InstanceTag) }
  let(:poll_instance_exists) { instance_double(PollInstanceExists) }
  let(:poll_instance_healthy) { instance_double(PollInstanceHealthy) }
  let(:instance_id) { 'my-instance-id' }

  let(:image_id) { 'image-id' }
  let(:min_count) { 1 }
  let(:max_count) { 1 }
  let(:monitoring) { true }

  let(:now) { Time.parse('2015 Jan 1 00:00:00') }

  let(:app_name) { 'my-app-name' }
  let(:build_number) { 'build12345' }

  let(:create_options) { {stdout: stdout, app_name: app_name, build_number: build_number, instance_type: nil} }
  let(:polling_options) { {stdout: stdout} }
  let(:instance_run_options) { {stdout: stdout, instance_type: nil} }

  # instance_id = start_instance(image_id)
  # tag_instance(instance_id)
  # poll_instance_running(instance_id)
  # poll_instance_patched(instance_id)
  # restart_instance(instance_id)
  # instance = poll_instance_running(instance_id)
  # poll_ssh(instance)


  # puts 'Starting Instance'
  # user_public_key = IO.read(File.join(ENV['HOME'], '.ssh', 'id_rsa.pub'))
  # user_data_template = File.join(File.dirname(__FILE__), 'files', 'base_ami_user_data.yaml.erb')
  # user_data = ErbParser.new(user_data_template, user_public_key: user_public_key).parse
  # run_response = @ec2.run_instances(
  #     image_id: image_id,
  #     min_count: 1,
  #     max_count: 1,
  #     instance_type: 'c4.large',
  #     monitoring: {enabled: true},
  #     user_data: Base64.encode64(user_data)
  # )
  # run_response[:instances].first[:instance_id]

  before(:each) do
    allow(aws_ec2_client).to receive(:create_tags).with(anything)
    allow(EC2InstanceRun).to receive(:new).with(config, image_id, min_count, max_count, monitoring, instance_run_options).and_return(ec2_instance_run)
    allow(ec2_instance_run).to receive(:execute).and_return(instance_id)
    allow(EC2InstanceTag).to receive(:new).with(config, instance_id, app_name, build_number).and_return(ec2_instance_tag)
    allow(ec2_instance_tag).to receive(:execute)
    allow(PollInstanceExists).to receive(:new).with(instance_id, polling_options).and_return(poll_instance_exists)
    allow(poll_instance_exists).to receive(:execute)
    allow(PollInstanceHealthy).to receive(:new).with(instance_id, polling_options).and_return(poll_instance_healthy)
    allow(poll_instance_healthy).to receive(:execute)
  end

  after(:each) do
    InstanceCreate.new(config, image_id, min_count, max_count, monitoring, create_options).execute
  end

  it 'should run a new EC2 instance from an AMI image' do
    expect(ec2_instance_run).to receive(:execute).and_return(instance_id)
  end

  it 'should Poll until the Instance exists' do
    expect(poll_instance_exists).to receive(:execute).and_return(nil)
  end

  it 'should tag a new EC2 instance' do
    expect(ec2_instance_tag).to receive(:execute)
  end

  it 'should wait until the instance is running' do
    expect(poll_instance_healthy).to receive(:execute)
  end


end