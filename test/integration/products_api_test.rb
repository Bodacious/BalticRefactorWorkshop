require "test_helper"

class ProductsAPITest < ActionDispatch::IntegrationTest
  test ".index returns all products" do
    get "/products"

    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 9, body.length
    assert_equal "iPhone 29 Super UltraMax", body.first["name"]
  end

  test ".show returns the product" do
    get "/products/1"

    assert_response :success

    body = JSON.parse(response.body)
    assert_equal "iPhone 29 Super UltraMax", body["name"]
  end

  test ".show returns 404 for missing record" do
    get "/products/0"

    assert_response :not_found

    body = JSON.parse(response.body)
    assert_equal ["Record not found"], body["errors"]
  end
end
