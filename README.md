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

## Example

```
aws = AwsHelpers::EC2.new

# get the id of a named AMI
ami = aws.images_find_by_tags(Name: 'My AMI').first

# create an instance and wait for it to come online
instance = aws.instance_create(ami.id)
aws.instance_start(instance.id)
aws.poll_instance_healthy(instance.id)
puts "Instance #{instance.id} is running!"

# stop the instance, wait for it to stop cleanly, and then destroy it
aws.instance_stop(instance.id)
aws.poll_instance_stopped(instance.id)
aws.instance_delete(instance.id)
```

## Advanced

You can pass options to the helper initialization method to set global options that
will be used for all internal clients, such as `:retry_attempts`

```
# set the retry attempts to a ridiculously high number for ALL clients used by this helper (e.g. EC2, S3, RDS etc.)
aws = AwsHelpers::EC2.new(retry_attempts: 99)
```

You can also pass custom implementations of individual AWS Clients. These will override the default
clients used by the helper

```
aws = AwsHelpers::EC2.new
aws.configure do |config|
  config.aws_ec2_client = MyAWSClients::EC2.new
end
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MYOB-Technology/aws_helpers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
