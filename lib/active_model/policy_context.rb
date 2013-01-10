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

    def can? action, object
      return false if object.nil?

      policy = object.respond_to?(:to_policy) && object.to_policy
      !policy || policy.can?(action, policy_context)
    end

    def can! action, object
      can?(action, object) || raise(ActiveModel::ActionNotAllowed, action)
    end

    def cannot? *args
      !can?(*args)
    end

    def cannot! action, object
      cannot?(action, object) || raise(ActiveModel::ActionUnexpected, action)
    end

    module ClassMethods
      def policy_context context
        self._policy_context = context
      end
    end
  end
end