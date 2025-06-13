class YamlProductRepository # Abstract Base class
  include YamlStorage
  include QueryMethods

  def all = Product.all

  def find(...) = Product.find(...)

  def where(...) = Product.where(...)

  def count = Product.count

  def destroy!(...) = Product.destroy!(...)

  def create(product) = product.save
end
