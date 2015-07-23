require "codeclimate-test-reporter"
require 'aws_helpers'

CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
