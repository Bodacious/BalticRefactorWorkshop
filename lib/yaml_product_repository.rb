
require "yaml/store"

require_relative "./yaml_storage"

class YAMLProductRepository
  DEFAULT_FILE_PATH = Rails.root.join("db", "#{Rails.env}.products.yml")

  extend YAMLStorage

  class << self
    def all = Product.all
    def find(...) = Product.find(...)
    def where(...) = Product.where(...)
    def count = Product.count
    def destroy!(...) = Product.destroy!(...)

    def create(product) = product.save
  end
end
