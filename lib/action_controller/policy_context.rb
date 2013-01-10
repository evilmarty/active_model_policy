module ActionController
  module PolicyContext
    def self.included base
      base.class_eval do
        include ActiveModel::PolicyContext
        policy_context :current_user
      end

      methods = ActiveModel::PolicyContext.instance_methods

      base.hide_action *methods
      base.helper_method :can?, :cannot?
    end
  end
end