class ProductRepositoryFactory
  def initialize(format)
    @adapter = "#{format.to_s.classify}ProductRepository".constantize.new
  end
  def method_missing(method, *args, &block)
    super unless @adapter.respond_to?(method)

    @adapter.public_send(method, *args, &block)
  end
end
