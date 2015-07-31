require 'rspec'
require 'aws_helpers/common/client'

# describe 'Calling the config configure method' do
#
#   let(:config) {  { test: 'value' } }
#
#   it 'should call the common config' do
#     expect(AwsHelpers::Common::Client.new(config).config).to match(config)
#   end
#
#   it 'should call the common configure override method' do
#     expect(AwsHelpers::Common::Client.new(config).to match(config)
#     AwsHelpers::Common::Client.configure
#   end
#
# end