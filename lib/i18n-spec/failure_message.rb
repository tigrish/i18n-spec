module I18nSpec
  module FailureMessage
    def failure_for_should
      if respond_to?(:failure_message)
        # Rspec 3
        failure_message { |f| yield(f) }
      else
        # Rspec 2
        failure_message_for_should { |f| yield(f) }
      end
    end

    def failure_for_should_not
      if respond_to?(:failure_message_when_negated)
        # Rspec 3
        failure_message_when_negated { |f| yield(f) }
      else
        # Rspec 2
        failure_message_for_should_not { |f| yield(f) }
      end
    end
  end
end
