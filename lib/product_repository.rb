
require_relative "./yaml_product_repository"

class ProductRepository
  def initialize(type) = @type = type

  def method_missing(method_name, *args, &block)
    super unless adapter.respond_to?(method_name)

    adapter.public_send(method_name, *args, &block)
  end

  def adapter = "#{@type.upcase}ProductRepository".constantize
end
