require "active_support/core_ext/class"

module ActiveModel
  module PolicyContext
    extend ActiveSupport::Concern

    included do
      class_attribute :_policy_context
    end

    def policy_context
      if _policy_context && respond_to?(_policy_context)
        send _policy_context
      else
        self
      end
    end

    # Ask whether the action is permissible.
    # @param [String, Symbol] action name of the action
    # @param [Object] object the object to check the action against. If the object does not have a policy file then it will pass by default.
    # @return [true, false] response to whether the action is allowed or not
    def can? action, object
      return false if object.nil?

      policy = object.respond_to?(:to_policy) && object.to_policy
      !policy || policy.can?(action, policy_context)
    end

    # Same as #can? but will raise ActiveModel::ActionNotAllowed when not allowed.
    def can! action, object
      can?(action, object) || raise(ActiveModel::ActionNotAllowed, action)
    end

    # The inverse of #can?
    # @params (see #can?)
    # @return (see #can?)
    def cannot? *args
      !can?(*args)
    end

    # Same as #cannot? but will raise ActiveModel::ActionUnexpected when allowed.
    def cannot! action, object
      cannot?(action, object) || raise(ActiveModel::ActionUnexpected, action)
    end

    module ClassMethods
      # Set the method used to retrieve the context, which is nil by default.
      # @param [String, Symbol] context the name of the method to call to retrieve the context. Can be nil to refer to itself.
      def policy_context context
        self._policy_context = context
      end
    end
  end
end