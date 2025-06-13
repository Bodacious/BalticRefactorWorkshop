class Rating < ApplicationRecord
  belongs_to :product
  belongs_to :user

  def self.for_product(product)
    where(product_id: product.id)
  end
end
