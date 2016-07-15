require 'aws_helpers/utilities/polling'
require 'aws_helpers/actions/elastic_load_balancing/instance_state'

module AwsHelpers
  module Actions
    module ElasticLoadBalancing
      class PollInServiceInstances
        include AwsHelpers::Utilities::Polling
        include AwsHelpers::Actions::ElasticLoadBalancing::InstanceState

        def initialize(config, load_balancer_names, options)
          @config = config
          @load_balancer_names = load_balancer_names
          @required_instances = options[:required_instances] ||= nil
          @poll_operator = options[:poll_operator] ||= '<='
          @stdout = options[:stdout] ||= $stdout
          @max_attempts = options[:max_attempts] ||= 20
          @delay = options[:delay] || 15
        end

        def execute
          client = @config.aws_elastic_load_balancing_client
          @load_balancer_names.each do |load_balancer_name|
            poll(@delay, @max_attempts) do
              instance_states = client.describe_instance_health(load_balancer_name: load_balancer_name).instance_states
              state_count = count_states(instance_states)
              in_service_count = instance_states.select { |s| s.state == IN_SERVICE }.count
              @stdout.puts("Load Balancer Name=#{load_balancer_name}#{create_state_output(state_count)}")
              if @required_instances.nil?
                in_service_count == instance_states.size
              else
                in_service_count.send(@poll_operator, @required_instances.to_i)
              end
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
