require 'yard'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require './lib/aws_helpers/config'
require './lib/aws_helpers/ec2_commands/requests/image_create_request'
require './lib/aws_helpers/ec2_commands/directors/image_create_director'

task :create_image do
  config = AwsHelpers::Config.new({})
  request = AwsHelpers::EC2::Requests::ImageCreateRequest.new
  request.instance_id = 'i-d5294a57'
  request.use_name = true
  AwsHelpers::EC2::Directors::ImageCreateDirector.new(config).create(request)
end

namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |task|
    task.pattern = 'spec/unit/**/*_spec.rb'
  end

  RSpec::Core::RakeTask.new(:integration) do |task|
    task.pattern = 'spec/integration/**/*_spec.rb'
  end
end

task spec: 'spec:unit'

task default: 'spec:unit'

YARD::Rake::YardocTask.new
