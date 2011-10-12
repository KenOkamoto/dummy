require 'test_helper'

class ClockControllerTest < ActionController::TestCase
  test "should get now" do
    get :now
    assert_response :success
  end

end
