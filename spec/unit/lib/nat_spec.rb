require 'time'
require 'aws_helpers/nat'

describe AwsHelpers::NAT do
  let(:subnet_id) { '13' }
  let(:allocation_id) { '42' }
  let(:gateway_id) { '99' }
  let(:create_request) { GatewayCreateRequest.new(subnet_id: subnet_id, allocation_id: allocation_id) }
  let(:delete_request) { GatewayDeleteRequest.new(gateway_id: gateway_id) }
  let(:create_director) { instance_double(GatewayCreateDirector) }
  let(:delete_director) { instance_double(GatewayDeleteDirector) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:image_name) { 'ec2_name' }

  before(:each) do
    allow(AwsHelpers::Config).to receive(:new).and_return(config)
    allow(GatewayCreateRequest).to receive(:new).and_return(create_request)
    allow(GatewayCreateDirector).to receive(:new).and_return(create_director)
    allow(GatewayDeleteRequest).to receive(:new).and_return(delete_request)
    allow(GatewayDeleteDirector).to receive(:new).and_return(delete_director)
    allow(create_director).to receive(:create)
    allow(delete_director).to receive(:delete)
  end

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::NAT.new(options)
    end
  end

  describe '#gateway_create' do
    it 'should create a GatewayCreateRequest with the correct parameters' do
      expect(GatewayCreateRequest)
        .to receive(:new)
        .with(subnet_id: subnet_id, allocation_id: allocation_id)
      AwsHelpers::NAT.new.gateway_create(subnet_id, allocation_id)
    end

    it 'should create a GatewayCreateDirector with the config' do
      expect(GatewayCreateDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::NAT.new.gateway_create(subnet_id, allocation_id)
    end

    it 'should call create on the GatewayCreateDirector' do
      expect(create_director)
        .to receive(:create)
        .with(create_request)
      AwsHelpers::NAT.new.gateway_create(subnet_id, allocation_id)
    end
  end

  describe '#gateway_delete' do
    it 'should create a GatewayDeleteRequest with the correct parameters' do
      expect(GatewayDeleteRequest)
        .to receive(:new)
        .with(gateway_id: gateway_id)
      AwsHelpers::NAT.new.gateway_delete(gateway_id)
    end

    it 'should delete a GatewayDeleteDirector with the config' do
      expect(GatewayDeleteDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::NAT.new.gateway_delete(gateway_id)
    end

    it 'should call delete on the GatewayDeleteDirector' do
      expect(delete_director)
        .to receive(:delete)
        .with(delete_request)
      AwsHelpers::NAT.new.gateway_delete(gateway_id)
    end
  end
end
