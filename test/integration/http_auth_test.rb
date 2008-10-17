require 'test/test_helper'

class HttpAuthTest < ActionController::IntegrationTest
  # fixtures :your, :models

  def test_page_is_http_auth_protected
    get '/'
    assert_response 401
  end
end

class HttpAuthHelperTest < ActionController::IntegrationTest
  def setup
    http_auth!
  end
  
  def test_page_can_authenticate
    get '/'
    assert_response :success
  end
  
  def test_page_can_deauthenticate
    no_http_auth!
    get '/'
    assert_response 401
  end
end
