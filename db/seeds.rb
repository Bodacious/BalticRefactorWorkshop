
Product.all.each do |product|
  next if product.ratings.any?

  random_count = (1..3).to_a.sample
  FactoryBot.create_list(:rating, random_count, product_id: product.id)
end
