require "active_support"
require "active_support/core_ext/string/inflections"

module ActiveModel::PolicySupport
  extend ActiveSupport::Concern

  def to_policy
    @policy ||= self.class.active_model_policy.new self
  end

  module ClassMethods
    if ''.respond_to?(:safe_constantize)
      def active_model_policy
        @active_model_policy ||= "#{self.name}Policy".safe_constantize
      end
    else
      def active_model_policy
        return @active_model_policy if defined? @active_model_policy

        @active_model_policy = "#{self.name}Policy".constantize
      rescue NameError
        nil
      end
    end
  end
end