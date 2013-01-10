require "active_support"
require "active_support/core_ext/string/inflections"

require "active_model"
require "active_model/policy"
require "active_model/policy_context"
require "active_model/policy_support"
require "active_model/version"

require "action_controller/policy_context"

module ActiveModel
  class ActionNotAllowed < StandardError; end
  class ActionUnexpected < StandardError; end

  if defined?(::Rails)
    class Railtie < Rails::Railtie
      generators do |app|
        app ||= Rails.application # Rails 3.0.x does not yield `app`

        ::Rails::Generators.configure!(app.config.generators)
        ::Rails::Generators.hidden_namespaces.uniq!
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include ActiveModel::PolicySupport
end

ActiveSupport.on_load(:action_controller) do
  include ActionController::PolicyContext
end

ActiveSupport.run_load_hooks(:active_model_policy, ActiveModel::Policy)
