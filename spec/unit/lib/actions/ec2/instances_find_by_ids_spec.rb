require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/instances_find_by_ids'

describe AwsHelpers::Actions::EC2::InstancesFindByIds do

  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }

  describe '#execute' do

    let(:id) { 'id' }
    let(:state) { nil }
    let(:instance) { Aws::EC2::Types::Instance.new(instance_id: id, state: Aws::EC2::Types::InstanceState.new(name: state)) }

    before(:each) do
      allow(ec2_client)
          .to receive(:describe_instances)
                  .and_return(
                      Aws::EC2::Types::DescribeInstancesResult.new(
                          reservations: [
                              Aws::EC2::Types::Reservation.new(instances: [instance])
                          ]
                      )

                  )
    end

    subject { described_class.new(config, [id]).execute }

    it 'should call Aws::EC2::Client #describe_instances with correct parameters' do
      expect(ec2_client).to receive(:describe_instances).with(instance_ids: [id])
      subject
    end

    context 'instances state is running' do

      let(:state) { 'running' }

      it 'should return the instance' do
        expect(subject.size).to eql(1)
      end

      it 'should return the instance matching the instance id' do
        expect(subject.first).to eql(instance)
      end

    end

    context 'instance state is not running' do

      let(:state) { 'other' }

      it 'should return an empty array' do
        expect(subject).to eql([])
      end

    end

  end

end
