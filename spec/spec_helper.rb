require 'aws_helpers'
require 'codeclimate-test-reporter'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

CodeClimate::TestReporter.start