module ActiveModel
  class Policy
    attr_reader :model

    # Initialise the policy for the given model.
    # @param [Object] model object to perform permission checks against.
    # @return new policy instance.
    def initialize model
      @model = model
    end

    # Return the model for the policy.
    alias_method :to_model, :model

    # Return the policy. ie. itself
    def to_policy
      self
    end

    # Asks questions as to whether the action can be performed.
    # @param [String, Symbol] action name of the action
    # @param [...] args passed to the question
    # @return [true, false] response for the action
    def can? action, *args
      method = "can_#{action}?"
      respond_to?(method) && !!safe_send(method, args)
    end

    # Same as #can? but will raise ActiveModel::ActionNotAllowed when response is false.
    # @param (see #can?)
    # @return [true]
    def can! action, *args
      can?(action, *args) || raise(ActiveModel::ActionNotAllowed, action)
    end

    # Inverse to #can?
    # @param (see #can?)
    # @return (see #can?)
    def cannot? *args
      !can? *args
    end

    # Same as #cannot? but will raise ActiveModel::ActionUnexpected when response is true.
    # @params (see #cannot?)
    # @return [true]
    def cannot! action, *args
      cannot?(action, *args) || raise(ActiveModel::ActionUnexpected, action)
    end

    # A macro for helping form the question.
    #
    # More than one action name can be given for same behaviour.
    # @param [String, Symbol, ...] actions name of one or more actions
    # @param [Proc] block can accept arguments, first one usually referring to the context
    def self.can *actions, &block
      raise ArgumentError if actions.empty?
      raise ArgumentError if block.nil?
      actions.flatten.each do |action|
        define_method "can_#{action}?", &block
      end
    end

  private

    def safe_send method_name, args
      method = public_method method_name

      if method.arity < args.length && method.arity != -1
        args = args.take method.arity
      end

      method.call *args
    end
  end
end