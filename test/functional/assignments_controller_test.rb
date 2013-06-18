require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  setup do
    @assignment = assignments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignment" do
    assert_difference('Assignment.count') do
      post :create, assignment: { all_day: @assignment.all_day, assignment_type: @assignment.assignment_type, clarify_start: @assignment.clarify_start, description: @assignment.description, duration_hours: @assignment.duration_hours, duration_minutes: @assignment.duration_minutes, ends_at: @assignment.ends_at, starts_at: @assignment.starts_at, title: @assignment.title }
    end

    assert_redirected_to assignment_path(assigns(:assignment))
  end

  test "should show assignment" do
    get :show, id: @assignment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assignment
    assert_response :success
  end

  test "should update assignment" do
    put :update, id: @assignment, assignment: { all_day: @assignment.all_day, assignment_type: @assignment.assignment_type, clarify_start: @assignment.clarify_start, description: @assignment.description, duration_hours: @assignment.duration_hours, duration_minutes: @assignment.duration_minutes, ends_at: @assignment.ends_at, starts_at: @assignment.starts_at, title: @assignment.title }
    assert_redirected_to assignment_path(assigns(:assignment))
  end

  test "should destroy assignment" do
    assert_difference('Assignment.count', -1) do
      delete :destroy, id: @assignment
    end

    assert_redirected_to assignments_path
  end
end
