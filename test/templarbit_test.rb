require 'test_helper'

class Templarbit::Test < ActionDispatch::IntegrationTest

  test "Content-Security-Policy header is sent" do
    get '/hello'
    assert_response :success
    assert_equal "test", response.headers["Content-Security-Policy"]
    assert_equal "test_report_only", response.headers["Content-Security-Policy-Report-Only"]
  end

end
