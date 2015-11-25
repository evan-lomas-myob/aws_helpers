require 'yard'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

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
