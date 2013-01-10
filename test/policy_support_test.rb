require 'test_helper'

class PolicySupportTest < ActiveModel::TestCase
  class Supporter
    include ActiveModel::PolicySupport
  end

  class SupporterPolicy < ActiveModel::Policy
  end

  class Unsupported
    include ActiveModel::PolicySupport
  end

  test ".active_model_policy returns the policy class" do
    assert_respond_to Supporter, :active_model_policy
    assert_equal SupporterPolicy, Supporter.active_model_policy
  end

  test ".active_model_policy returns nil when no policy class can be found" do
    assert_respond_to Unsupported, :active_model_policy
    assert_nil Unsupported.active_model_policy
  end

  test "#to_policy returns the policy instance setting itself as the model" do
    model = Supporter.new
    policy = model.to_policy
    assert_equal model, policy.model
  end
end