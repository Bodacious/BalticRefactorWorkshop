
module YAMLStorage
  DEFAULT_FILE_PATH = Rails.root.join("db", "#{Rails.env}.products.yml")

  # Set the filepath where the YAML data is stored
  # @param [Pathname, String] filepath
  # @return [Pathname]
  def database_filepath=(filepath)
    @database_filepath = Pathname.new(filepath)
  end

  # The filepath where the YAML data is stored
  # @return [Pathname]
  def database_filepath
    @database_filepath || DEFAULT_FILE_PATH
  end

  def store_instance(read_only: true, &block)
    ensure_db_exists!

    store = YAML::Store.new(database_filepath.to_s, threadsafe = true)

    store.transaction(read_only) do
      block.call(store)
    end
  end

  # YAML::Store doesn't like it if we try to save data-types not in the permitted
  # class list.
  SAFE_YAML_TYPES = [
    TrueClass,
    FalseClass,
    NilClass,
    Integer,
    Float,
    String,
    Array,
    Hash
  ].freeze
  private_constant :SAFE_YAML_TYPES

  # Ensure we store data in YAML-safe types
  # @param [Hash] attributes
  # @return [Hash]
  def safe_storage_attributes(attributes)
    attributes.transform_values do |value|
      next(value) if SAFE_YAML_TYPES.include?(value.class)

      next(value.to_f) if value.is_a?(Numeric)

      value.to_s
    end
  end

  # The key to save the product under in YAML. Saves as a dictionary, rather
  # than a list, for faster lookup.
  # (e.g. faster to find `product_hash["1-product"]`
  # than `products_array.find { |item| item.id == "1-product"}`.
  # Storage keys are ID first, so that they are faster to sort than if the ID
  # came at the end of the String.
  def storage_key_for_product(product)
    product.id = generate_new_id_for_product! unless product.persisted?
    "#{product.id}-product"
  end

  def generate_new_id_for_product!
    max(:id).to_i + 1
  end

  def load_all
    ensure_db_exists!
    store_instance(read_only: true) do |store|
      store.keys.sort.map do |key|
        product_yaml = store[key]
        instance = new
        instance.attributes = product_yaml
        instance
      end
    end
  end

  def ensure_db_exists!
    return if File.exist?(database_filepath)

    FileUtils.mkdir_p(File.dirname(database_filepath))
    FileUtils.touch(File.dirname(database_filepath))
  end
end
