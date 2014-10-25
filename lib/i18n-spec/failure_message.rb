module I18nSpec
  module FailureMessage
    def failure_for_should(&block)
      if respond_to?(:failure_message)
        # Rspec 3
        failure_message { |f| instance_exec(f, &block) }
      else
        # Rspec 2
        failure_message_for_should { |f| instance_exec(f, &block) }
      end
    end

    def failure_for_should_not(&block)
      if respond_to?(:failure_message_when_negated)
        # Rspec 3
        failure_message_when_negated { |f| instance_exec(f, &block) }
      else
        # Rspec 2
        failure_message_for_should_not { |f| instance_exec(f, &block) }
      end
    end
  end
end
