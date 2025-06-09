FactoryBot.define do
  factory :product do
    sequence(:id) { |n| n }
    sequence(:sku) { |n| "ACME-X#{n.to_s.rjust(3, '0')}" }
    sequence(:name) { |n| "Product #{n}" }
    sequence(:description) { |n| "Description for product #{n}" }
    price_amount { 9.99 }
    price_currency { "USD" }
    tax_amount { 1.99 }
    tax_currency { "USD" }
    stock { 10 }
  end
end
