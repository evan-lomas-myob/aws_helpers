require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/auto_scaling/resume_alarm_process'

describe AwsHelpers::Actions::AutoScaling::ResumeAlarmProcess do
  describe '#execute' do
    let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }
    let(:stdout) { instance_double(IO) }
    let(:auto_scaling_group_name) { 'name' }
    let(:payload) {{auto_scaling_group_name: auto_scaling_group_name, scaling_processes: ['AlarmNotification']}}

    describe '#execute' do
      before(:each) do
        allow(stdout).to receive(:puts)
      end

      it 'should call add_tags with correct parameters on the AWS::ElasticLoadBalancing::Client' do
        expect(auto_scaling_client).to receive(:resume_processes).with(payload).and_return([])
        AwsHelpers::Actions::AutoScaling::ResumeAlarmProcess.new(config, auto_scaling_group_name, stdout: stdout).execute
      end

    end

  end
end
