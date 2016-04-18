require 'aws_helpers/actions/rds/instance_state'
require 'aws_helpers/utilities/polling'
require 'aws_helpers/elb_commands/commands/command'

module AwsHelpers
  module ELBCommands
    module Commands
      class PollInServiceInstancesCommand < AwsHelpers::ELBCommands::Commands::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @elb_client = config.aws_elastic_load_balancing_client
          @request = request
        end

        def execute
          @request.load_balancer_names.each do |load_balancer_name|
            poll(@request.instance_polling[:delay], @request.instance_polling[:max_attempts]) do
              instance_states = @elb_client.describe_instance_health(load_balancer_name: load_balancer_name).instance_states
              state_count = count_states(instance_states)
              std_out.puts("Load Balancer Name=#{load_balancer_name}#{create_state_output(state_count)}")
              instance_states.select { |s| s.state == 'InService' }.count == instance_states.size
            end
          end
        end

        private

        def create_state_output(state_count)
          state_count.sort.map { |state| ", #{state.join('=')}" }.join
        end

        def count_states(instances)
          instances.inject(Hash.new(0)) do |hash, instance| # rubocop:disable Style/EachWithObject
            hash[instance.state] += 1
            hash
          end
        end
      end
    end
  end
end
