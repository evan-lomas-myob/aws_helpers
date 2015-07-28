if ENV['COVERALLS_REPO_TOKEN']
  require 'coveralls'
  Coveralls.wear!
end

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end
