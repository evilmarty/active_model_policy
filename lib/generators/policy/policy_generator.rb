module Rails
  module Generators
    class PolicyGenerator < NamedBase
      source_root File.expand_path("../templates", __FILE__)
      check_class_collision :suffix => "Policy"

      def create_serializer_file
        template 'policy.rb', File.join('app/policies', class_path, "#{file_name}_policy.rb")
      end

    private

      def parent_class_name
        if defined?(::ApplicationPolicy)
          "ApplicationPolicy"
        else
          "ActiveModel::Policy"
        end
      end
    end
  end
end