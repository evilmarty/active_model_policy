require 'test_helper'

class PolicyTest < ActiveModel::TestCase
  test "#initialize sets the model" do
    model = Object.new
    policy = ActiveModel::Policy.new model

    assert_equal model, policy.model
  end

  test "#to_policy returns itself" do
    policy = ActiveModel::Policy.new nil
    assert_equal policy, policy.to_policy
  end

  test "#can? returns false when method not defined" do
    policy = ActiveModel::Policy.new nil
    refute policy.can?(:foobar)
  end

  test "#can? returns false when method returns false" do
    policy = TestModelPolicy.new nil
    refute policy.can_bar?
    refute policy.can?(:bar)
  end

  test "#can? returns true when method returns true" do
    policy = TestModelPolicy.new nil
    assert policy.can_foo?
    assert policy.can?(:foo)
  end

  test "#can? passes arguments to block" do
    policy = TestModelPolicy.new nil
    assert_nil policy.args
    assert policy.can?(:receive_args, :boo, :hoo)
    assert_equal [:boo, :hoo], policy.args
  end

  test "#can? culls excessive arguments" do
    policy = TestModelPolicy.new nil
    assert_nil policy.args
    assert policy.can?(:receive_args, :boo, :hoo, :abc)
    assert_equal [:boo, :hoo], policy.args
  end

  test "#cannot? returns true when method returns false" do
    policy = TestModelPolicy.new nil
    refute policy.can_bar?
    assert policy.cannot?(:bar)
  end

  test "#cannot? returns false when method returns true" do
    policy = TestModelPolicy.new nil
    assert policy.can_foo?
    refute policy.cannot?(:foo)
  end

  test "#can! returns true when method returns true" do
    policy = TestModelPolicy.new nil
    assert policy.can_foo?
    assert policy.can!(:foo)
  end

  test "#can! raises error when method returns false" do
    policy = TestModelPolicy.new nil
    refute policy.can_bar?
    assert_raises ActiveModel::ActionNotAllowed do
      policy.can!(:bar)
    end
  end

  test "#cannot! returns true when method returns false" do
    policy = TestModelPolicy.new nil
    refute policy.can_bar?
    assert policy.cannot!(:bar)
  end

  test "#cannot! raises error when method returns true" do
    policy = TestModelPolicy.new nil
    assert policy.can_foo?
    assert_raises ActiveModel::ActionUnexpected do
      policy.cannot!(:foo)
    end
  end

  test ".can defines a method" do
    refute TestModelPolicy.method_defined?(:can_foobar?)
    TestModelPolicy.can(:foobar){ true }
    assert TestModelPolicy.method_defined?(:can_foobar?)
  end

  test ".can defines multiple methods when given multiple arguments" do
    refute TestModelPolicy.method_defined?(:can_boo?)
    refute TestModelPolicy.method_defined?(:can_hoo?)
    TestModelPolicy.can(:boo, :hoo){ true }
    assert TestModelPolicy.method_defined?(:can_boo?)
    assert TestModelPolicy.method_defined?(:can_hoo?)
  end
end
