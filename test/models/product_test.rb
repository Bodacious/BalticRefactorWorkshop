require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "attribute defaults are set correctly" do
    product = Product.new
    assert_nil product.id
    assert_equal "", product.sku
    assert_equal "", product.name
    assert_equal "", product.description
    assert_equal "USD", product.price_currency
    assert_equal "USD", product.tax_currency
    assert_equal 0, product.stock
    assert_equal 0.0, product.price_amount
    assert_equal 0.0, product.tax_amount
  end

  test "#persisted? returns false if the product has no ID" do
    product = Product.new
    refute product.persisted?
  end

  test "#price returns a Money object with the correct amount and currency" do
    product = Product.new(price_amount: 19.99, price_currency: "USD")
    assert_equal Money.from_amount(19.99, "USD"), product.price
  end

  test "#tax returns a Money object with the correct amount and currency" do
    product = Product.new(tax_amount: 1.99, tax_currency: "USD")
    assert_equal Money.from_amount(1.99, "USD"), product.tax
  end

  test "#attributes= sets the attributes correctly" do
    product = Product.new
    product.attributes = { id: 1, name: "Product A", price_amount: 9.99 }
    assert_equal 1, product.id
    assert_equal "Product A", product.name
    assert_equal 9.99, product.price_amount
  end

  test "#initialize sets attributes on creation" do
    product = Product.new(id: 1, name: "Product A")
    assert_equal 1, product.id
    assert_equal "Product A", product.name
  end

  test "#price handles nil amount" do
    product = Product.new(price_amount: nil, price_currency: "USD")
    assert_equal Money.from_amount(0.0, "USD"), product.price
  end
end
