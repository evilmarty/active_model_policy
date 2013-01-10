class TestContext
  include ActiveModel::PolicyContext

  def current_user
    :user
  end
end

class TestModel
  include ActiveModel::PolicySupport
end

class TestModelPolicy < ActiveModel::Policy
  attr_reader :context, :args

  def can_recieve_context? context
    @context = context
    true
  end

  def can_foo?
    true
  end

  def can_bar?
    false
  end

  def can_receive_args? arg1, arg2
    @args = [arg1, arg2]
    true
  end
end

class TestContextController
  class << self
    attr_reader :actions, :methods
    def hide_action *actions
      @actions = actions
    end

    def helper_method *methods
      @methods = methods
    end
  end

  include ActionController::PolicyContext

  def current_user
    :user
  end
end