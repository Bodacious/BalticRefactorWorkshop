require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  test "#index returns 200 success" do
    get products_url, as: :json

    assert_response :success
  end

  test "#index loads all products" do
    Product.expects(:all).returns([]).at_least_once

    get products_url, as: :json

    assert_response :success
  end

  test "#index renders all products as json" do
    products = build_list :product, 3
    products.each { |prod| prod.expects(:as_json).returns(prod.attributes) }
    Product.stubs(:all).returns(products)

    get products_url, as: :json
  end

  test "#show returns a 200 success" do
    product = build_stubbed(:product)
    Product.expects(:find).returns(product)

    get product_url(product), as: :json

    assert_response :success
  end

  test "#show fetches the Product from the id param" do
    product = build(:product, id: 0)
    Product.expects(:find).with("0").returns(product)

    get product_url(id: "0"), as: :json

    assert_response :success
  end
end
