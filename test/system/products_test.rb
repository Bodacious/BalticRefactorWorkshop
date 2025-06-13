require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  test "Admin views all products" do
    FactoryBot.create(:product, name: "Widget A")
    FactoryBot.create(:product, name: "Widget B")

    visit products_path

    assert_text "Widget A"
    assert_text "Widget B"
  end

  test "Admin successfully adds a new product" do
    visit new_product_path

    fill_in "Name", with: "Test Product"
    fill_in "Sku", with: "TEST-X123"
    fill_in "Description", with: "A new test product"
    fill_in "Price amount", with: "19.99"
    fill_in "Price currency", with: "USD"
    fill_in "Stock", with: "5"

    click_on "Create Product"

    assert_current_path products_path
    assert_text "Product was successfully created"
    assert_text "Test Product"
  end

  test "Admin fails to create a new product (invalid input)" do
    visit new_product_path

    click_on "Create Product"

    assert_text "prohibited this product from being saved"
    assert_text "Name can't be blank"
    assert_text "Sku can't be blank"
    assert_text "Description can't be blank"
    assert_text "Price amount must be greater than 0"
    assert_text "Tax amount must be greater than 0"
  end

  test "Admin edits an existing product" do
    product = FactoryBot.create(:product, name: "Old Name", sku: "EDIT-X123")

    visit products_path
    within "#product_#{product.id}" do
      click_on "Edit", match: :first
    end

    assert_current_path edit_product_path(product)

    fill_in "Name", with: "Updated Name"
    click_on "Update Product"

    assert_current_path products_path
    assert_text "Product was successfully updated"
    assert_text "Updated Name"
  end

  test "Admin fails to edit an existing product (invalid input)" do
    product = FactoryBot.create(:product, name: "Initial Name", sku: "BADX-X123")

    visit edit_product_path(product)

    fill_in "Name", with: ""
    fill_in "Price amount", with: "0"
    click_on "Update Product"

    assert_text "prohibited this product from being saved"
    assert_text "Name can't be blank"
    assert_text "Price amount must be greater than 0"

    visit products_path
    assert_text "Initial Name"
  end

  test "Admin destroys an existing product" do
    product = FactoryBot.create(:product, name: "To Delete")

    visit products_path
    assert_text "To Delete"

    within "#product_#{product.id}" do
      click_on "Delete"
    end

    assert_text "Product was successfully destroyed"
    assert_no_text "To Delete"
    assert_current_path products_path
  end

  test "Admin changes price on Product" do
    product = FactoryBot.create(:product, price_amount: 100.0)

    visit products_path
    within "#product_#{product.id}" do
      click_on "Edit"
    end

    fill_in :product_price_amount, with: 200.0
    click_on "Update Product"

    assert_current_path products_path
    within "#product_#{product.id}" do
      assert_text "$40.00" # 20% of $200
    end
  end
end
