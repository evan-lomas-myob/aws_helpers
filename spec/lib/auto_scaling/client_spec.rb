require 'rspec'
require 'aws_helpers/auto_scaling/client'
require 'aws_helpers/auto_scaling/retrieve_desired_capacity'
require 'aws_helpers/auto_scaling/update_desired_capacity'

describe AwsHelpers::AutoScaling::Client do

  let(:group_name) { 'my_group_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::AutoScaling::Client).to receive(:new).with(options).and_return(AwsHelpers::AutoScaling::Config)
      AwsHelpers::AutoScaling::Client.new(options)
    end

  end

end