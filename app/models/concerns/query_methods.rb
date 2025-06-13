module QueryMethods
  # All of the products
  # @return [Array<Product>]
  def all
    load_all
  end

  # The maximum value of the given attribute name in the dataset
  # @param [String, Symbol] attribute_name Name of the attribute to return max value for
  # @return [String,Integer,Float]
  def max(attribute_name)
    load_all.select { |record| record.public_send(attribute_name).present? }
            .map(&:"#{attribute_name}")
            .max
  end

  # You tried to fetch a record that doesn't exist
  class Product::RecordNotFound < StandardError
  end

  # @param [Integer, String] id The ID of the product to find
  # @return [Product]
  # @raise [RecordNotFound]
  def find(id)
    where("id" => id.to_i).first || raise(RecordNotFound, "Cannot find product with id=#{id}")
  end



  # @param [Hash] filters The SQL filters to apply to this query.
  # @return [Array<Product>]
  def where(filters = {})
    load_all.filter do |product|
      product.attributes.with_indifferent_access.slice(*filters.keys) ==
        filters.with_indifferent_access
    end
  end



  def count
    all.size
  end

end
