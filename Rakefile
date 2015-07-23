require 'yard'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

=begin
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end
=end

task default: 'spec'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', '-', 'CODE_OF_CONDUCT.md', 'LICENSE.txt']
  t.options = ['--title', 'AWS Helpers Documentation', '--output-dir', 'aws-helper-docs', '--no-private', '--protected']
end
