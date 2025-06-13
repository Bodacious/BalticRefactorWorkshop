FactoryBot.define do
  factory :product do
    sequence(:id) { |n| n }
    sequence(:sku) { |n| "ACME-X#{n.to_s.rjust(3, '0')}" }
    name {  Faker::Commerce.product_name }
    description { |product| "#{product.name} by #{Faker::Commerce.brand}" }
    price_amount { Faker::Commerce.price }
    price_currency { "USD" }
    stock { (0..10).to_a.sample }
  end
end
