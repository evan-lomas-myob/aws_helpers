require 'aws-sdk-core'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_tag_value'
require 'recursive-open-struct'

include AwsHelpers::Actions::EC2

describe PollInstanceTagValue do
  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:instance_id) { 'i-de42f500' }
  let(:tag_key) { 'status' }
  let(:test_tag_key) { 'test' }
  let(:tag_value) { 'COMPLETE' }

  let (:describe_instance_result) {
    RecursiveOpenStruct.new({reservations: [ { instances: [{instance_id: instance_id,
                                                            tags: [{key: "status",
                                                                    value: "COMPLETE"}]
                                                           }]
                                             }]
                            },
                            recurse_over_arrays: true)
  }

  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 2 }
  let(:options) { { stdout: stdout, delay: 0, max_attempts: max_attempts } }

  describe '#execute' do
    before(:each) do
      allow(stdout).to receive(:puts)
    end

    it 'should use the AwsHelpers::Utilities::Polling to poll until the tag value for the specified tag key is in the expect state' do
      expect(aws_ec2_client).to receive(:describe_instances).with(instance_ids: [instance_id]).and_return(
          create_status_result("started"),create_status_result("COMPLETE"),
      )
      PollInstanceTagValue.new(config, instance_id, "status", "COMPLETE", options).execute
    end

    it 'should raise an exception if polling reaches max attempts' do
      allow(aws_ec2_client).to receive(:describe_instances).and_return(create_status_result("ERROR"))
      expect { PollInstanceTagValue.new(config, instance_id, tag_key, tag_value, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end

    it 'should write the status to stdout' do
      expect(stdout).to receive(:puts).with("#{instance_id} #{tag_key}=#{tag_value} (expected #{tag_value})")
      allow(aws_ec2_client).to receive(:describe_instances).and_return(create_status_result(tag_value))
      PollInstanceTagValue.new(config, instance_id, tag_key, tag_value, options).execute
    end

    it 'should write to stdout when tag key is not found and raise exception for max attempts' do
      expect(stdout).to receive(:puts).with("#{instance_id} #{test_tag_key} not found (expected #{tag_value})")
      allow(aws_ec2_client).to receive(:describe_instances).and_return(create_status_result(tag_value))
      expect { PollInstanceTagValue.new(config, instance_id, test_tag_key, tag_value, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end
  end

  def create_status_result(status)
    RecursiveOpenStruct.new({reservations: [ { instances: [{instance_id: instance_id,
                                                            tags: [{key: "status",
                                                                    value: status}]
                                                           }]
                                             }]
                            },
                            recurse_over_arrays: true)
  end
end
