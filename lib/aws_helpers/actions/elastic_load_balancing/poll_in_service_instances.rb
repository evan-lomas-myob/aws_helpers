require 'aws_helpers/utilities/generic_waiter'

include AwsHelpers::Utilities

module AwsHelpers
  module Actions
    module ElasticLoadBalancing

      class PollInServiceInstances

        IN_SERVICE = 'InService'

        def initialize(config, load_balancer_names, options)
          @config = config
          @load_balancer_names = load_balancer_names
          @stdout = options[:stdout] ||= $stdout
          @max_attempts = options[:max_attempts] ||= 20
          @delay = options[:delay] || 15
        end

        def execute
          client = @config.aws_elastic_load_balancing_client
          @load_balancer_names.each { |load_balancer_name|
            AwsHelpers::Utilities::GenericWaiter.new.wait_unit(@delay, @max_attempts) { |waiter|
              response = client.describe_instance_health(load_balancer_name: load_balancer_name)
              instance_states = response.instance_states
              state_count = count_states(instance_states)
              state_output = create_state_output(state_count)
              @stdout.puts("Load Balancer Name=#{load_balancer_name}#{state_output}")
              waiter.stop = state_count[IN_SERVICE] == instance_states.size
            }
          }
        end

        private

        def create_state_output(state_count)
          state_count.sort_by { |name| name }.map { |state| ", #{state.join('=')}" }.join
        end

        def count_states(instances)
          instances.inject(Hash.new(0)) { |hash, instance| hash[instance.state] += 1; hash }
        end

      end
    end

  end
end
