require 'test_helper'

class ControllerTest < ActiveModel::TestCase
  test "#policy_context defaults to :current_user" do
    assert_equal :current_user, TestContextController._policy_context
  end

  test "context methods are hidden from controller actions" do
    actions = TestContextController.actions.sort
    assert_equal [:can!, :can?, :cannot!, :cannot?, :policy_context], actions
  end

  test "helper methods are added for view" do
    assert_equal [:can?, :cannot?], TestContextController.methods
  end
end