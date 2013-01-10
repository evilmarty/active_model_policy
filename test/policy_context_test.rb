require 'test_helper'

class PolicyContextTest < ActiveModel::TestCase
  test ".policy_context sets the context" do
    refute_equal :test, TestContext._policy_context
    TestContext.policy_context :test
    assert_equal :test, TestContext._policy_context
  end

  test "#policy_context calls the context" do
    TestContext.policy_context :current_user
    context = TestContext.new
    assert_equal :user, context.policy_context
  end

  test "#policy_context returns itself when context is nil" do
    TestContext.policy_context nil
    context = TestContext.new
    assert_equal context, context.policy_context
  end

  test "#policy_context returns itself when context is not defined" do
    TestContext.policy_context :foobar
    context = TestContext.new
    refute_respond_to context, :foobar
    assert_equal context, context.policy_context
  end

  test "#can? returns true when object doesn't have a policy" do
    object = Object.new
    context = TestContext.new
    assert context.can?(:test, object)
  end

  test "#can? returns true when object has policy and permits action" do
    model = TestModel.new
    policy = model.to_policy
    context = TestContext.new
    assert context.can?(:recieve_context, model)
    assert_equal context, policy.context
  end

  test "#can? returns false when object has policy but doesn't permit action" do
    model = TestModel.new
    context = TestContext.new
    refute context.can?(:bar, model)
  end

  test "#can? returns false when object is nil" do
    context = TestContext.new
    refute context.can?(:foo, nil)
  end

  test "#can! raises error when object doesn't permit action" do
    model = TestModel.new
    context = TestContext.new
    assert_raises ActiveModel::ActionNotAllowed do
      context.can!(:bar, model)
    end
  end

  test "#can! returns true when action permitted" do
    model = TestModel.new
    context = TestContext.new
    assert context.can!(:foo, model)
  end

  test "#cannot? returns true when action is not allowed" do
    model = TestModel.new
    context = TestContext.new
    assert context.cannot?(:bar, model)
  end

  test "#cannot? returns false when action is allowed" do
    model = TestModel.new
    context = TestContext.new
    refute context.cannot?(:foo, model)
  end

  test "#cannot! raises error when action is allowed" do
    model = TestModel.new
    context = TestContext.new
    assert_raises ActiveModel::ActionUnexpected do
      context.cannot!(:foo, model)
    end
  end

  test "#cannot! returns true when action is not allowed" do
    model = TestModel.new
    context = TestContext.new
    assert context.cannot!(:bar, model)
  end
end