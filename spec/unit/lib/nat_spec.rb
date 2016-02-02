require 'time'
require 'aws_helpers/nat'

describe AwsHelpers::NAT do

  let(:subnet_id) { '1' }
  let(:allocation_id) { '1' }
  let(:config) { double(AwsHelpers::Config) }
  let(:image_name) { 'ec2_name' }

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::NAT.new(options)
    end
  end

  describe '#gateway_create' do

    let(:gateway_create) { double(GatewayCreate) }

    # let(:instance_id) { 'ec2_id' }
    # let(:tags) { %w('tag1', 'tag2') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(GatewayCreate).to receive(:new).and_return(gateway_create)
      allow(gateway_create).to receive(:execute)
    end

    it 'should create GatewayCreate with default parameters' do
      expect(GatewayCreate).to receive(:new).with(config, subnet_id, allocation_id)
      AwsHelpers::NAT.new.gateway_create(subnet_id, allocation_id)
    end

    it 'should call GatewayCreate execute method' do
      expect(gateway_create).to receive(:execute)
      AwsHelpers::NAT.new.gateway_create(subnet_id, allocation_id)
    end

  end

  describe '#gateway_delete' do

    let(:gateway_delete) { double(GatewayDelete) }
    let(:gateway_id) { '1' }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(GatewayDelete).to receive(:new).and_return(gateway_delete)
      allow(gateway_delete).to receive(:execute)
    end

    subject { AwsHelpers::NAT.new.gateway_delete(gateway_id) }

    it 'should create GatewayDelete with parameters' do
      expect(GatewayDelete).to receive(:new).with(config, gateway_id)
      subject
    end

    it 'should call GatewayDelete execute method' do
      expect(gateway_delete).to receive(:execute)
      subject
    end

  end

end
