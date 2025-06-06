require 'sqlite3'
require 'active_record'

# Establish DB connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.third-party.sqlite3'
)

# Create products table if it doesn't exist
ActiveRecord::Schema.define do
  create_table :products, force: true do |t|
    t.string  :stock_keeping_unit_code, null: false
    t.integer :stock_count, default: 0, null: false
    t.string  :display_name, null: false
    t.integer :rating, default: nil, null: false
    t.text    :details
    t.text    :info
    t.decimal  :price_amount, precision: 10, scale: 2, default: 0.0, null: false
    t.string  :price_currency, null: false
    t.decimal  :tax_amount, precision: 10, scale: 2, default: 0.0, null: false
    t.string  :tax_currency, null: false
    t.timestamps
  end unless table_exists? :products
end
