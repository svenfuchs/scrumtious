require 'test_helper'

class ReleasesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:releases)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_release
    assert_difference('Release.count') do
      post :create, :release => { }
    end

    assert_redirected_to release_path(assigns(:release))
  end

  def test_should_show_release
    get :show, :id => releases(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => releases(:one).id
    assert_response :success
  end

  def test_should_update_release
    put :update, :id => releases(:one).id, :release => { }
    assert_redirected_to release_path(assigns(:release))
  end

  def test_should_destroy_release
    assert_difference('Release.count', -1) do
      delete :destroy, :id => releases(:one).id
    end

    assert_redirected_to project_path(@release.project)
  end
end
