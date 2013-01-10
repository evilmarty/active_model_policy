module ActiveModel
  class Policy
    attr_reader :model

    def initialize model
      @model = model
    end

    alias_method :to_model, :model

    def to_policy
      self
    end

    def can? action, *args
      method = "can_#{action}?"
      respond_to?(method) && !!safe_send(method, args)
    end

    def can! action, *args
      can?(action, *args) || raise(ActiveModel::ActionNotAllowed, action)
    end

    def cannot? *args
      !can? *args
    end

    def cannot! action, *args
      cannot?(action, *args) || raise(ActiveModel::ActionUnexpected, action)
    end

    def self.can *actions, &block
      raise ArgumentError if actions.empty?
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