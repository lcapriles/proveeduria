require 'test_helper'

class ComprasControllerTest < ActionController::TestCase
  test "should get indez" do
    get :indez
    assert_response :success
  end

end
