# AwsHelpers

[![Build Status](https://travis-ci.org/MYOB-Technology/aws_helpers.png?branch=rewrite)](https://travis-ci.org/MYOB-Technology/aws_helpers)
[![Coverage Status](https://coveralls.io/repos/MYOB-Technology/aws_helpers/badge.svg?branch=rewrite&service=github)](https://coveralls.io/github/MYOB-Technology/aws_helpers?branch=rewrite)

The AWS Helpers gem provides a range of utility classes to manage resources within AWS.

## Installation

Adds this line to your application's Gemfile:

```ruby
gem 'aws_helpers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_helpers

## Usage

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Available Helpers

### {AutoScaling}
List instances, query desired capacity or update the desired capacity for a particular AutoScaling group

### {CloudFormation}
Create, modify or deploy CloudFormation stacks, including ChangeSets

### {EC2}
Create and delete EC2 AMIs and instances, as well as utilities to poll for a particular instance state.

### {ElasticLoadBalancing}
Query the current number of instances that are 'In Service' for a particular ELB

### {KMS}
Retrieve ARN information about keys using their alias

### {NAT}
Create and delete NAT gateways

### {RDS}
Create and delete RDS snapshots

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MYOB-Technology/aws_helpers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
