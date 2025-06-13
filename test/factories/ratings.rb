FactoryBot.define do
  factory :rating do
    product_id { create(:product).id }
    user
    star_value { (1..5).to_a.sample }
    comment { Faker::Lorem.sentence }
  end
end
