module AwsHelpers
  module Actions
    module ElasticLoadBalancing

      class PollHealthyInstances

        IN_SERVICE = 'InService'
        OUT_OF_SERVICE = 'OutOfService'
        UNKNOWN = 'Unknown'

        def initialize(stdout, config, load_balancer_name, expected_number, timeout)
          @stdout = stdout
          @config = config
          @load_balancer_name = load_balancer_name
          @expected_number = expected_number
          @timeout = timeout
        end

        def execute
          #TODO: Is expected_number actually needed?
          client = @config.aws_elastic_load_balancing_client
          client.wait_until(:instance_in_service, load_balancer_names: [@load_balancer_name]) { |waiter|
            waiter.max_attempts = @timeout / waiter.delay
            waiter.before_wait do |_attempts, response|
              instance_states = response.instance_states
              in_service_count = instance_states.select{|instance_state| instance_state.state == IN_SERVICE }.count
              out_of_service = instance_states.count - in_service_count
              @stdout.puts "In Service: #{in_service_count} Out of Service: #{out_of_service}"
            end
          }

        end
      end

    end
  end
end