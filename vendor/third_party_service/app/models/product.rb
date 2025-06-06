# Define Product model
class Product < ActiveRecord::Base
  attribute :price_amount, :decimal, default: 0
  attribute :tax_amount, :decimal, default: 0
  validates :stock_keeping_unit_code, :display_name, :price_amount, :price_currency, :stock_count, presence: true
end
