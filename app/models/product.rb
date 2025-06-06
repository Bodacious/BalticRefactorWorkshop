# An item for sale in our online store.
#
# Saved in YAML for now, because we can't afford a DB
#
class Product
  include ActiveModel::Model
  include ActiveModel::Attributes

  # You tried to fetch a record that doesn't exist
  class RecordNotFound < StandardError
  end

  ##
  # Default currency code for each money value
  DEFAULT_ISO_CURRENCY = "USD"
  ##
  # Pattern for a valid SKU
  SKU_PATTERN = /\w{4}\-\w?\d{3}/i

  ##
  # Pattern for a valid ISO Currency Code
  ISO_CURRENCY_PATTERN = /[A-Z]{3}/

  ##
  # YAML Persistence. Matches ActiveRecord's API as much as possible

  class << self
    require "yaml/store"

    # Default database path.
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

    # All of the products
    # @return [Array<Product>]
    def all
      load_all
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

    protected

    def store_instance(read_only: true, &block)
      ensure_db_exists!

      store = YAML::Store.new(database_filepath.to_s, threadsafe = true)

      store.transaction(read_only) do
        block.call(store)
      end
    end

    def load_all
      ensure_db_exists!
      store_instance(read_only: true) do |store|
        store.keys.sort.map do |key|
          product_yaml = store[key]
          Product.new(product_yaml)
        end
      end
    end

    def ensure_db_exists!
      return if File.exist?(database_filepath)

      FileUtils.mkdir_p(File.dirname(database_filepath))
      FileUtils.touch(File.dirname(database_filepath))
    end
  end

  attribute :id, :integer, default: nil

  attribute :sku, :string, default: ""

  attribute :name, :string, default: ""

  attribute :description, :string, default: ""

  attribute :price_amount, :decimal, precision: 10, scale: 2, default: 0.0

  attribute :price_currency, :string, default: DEFAULT_ISO_CURRENCY

  attribute :tax_amount, :decimal, precision: 10, scale: 2, default: 0.0
  attribute :tax_currency, :string, default: DEFAULT_ISO_CURRENCY

  attribute :stock, :integer, default: 0

  validates :name, presence: true

  validates :sku, presence: true, format: SKU_PATTERN

  validates :description, presence: true

  validates :price_amount, presence: true, numericality: { greater_than: 0 }

  validates :price_currency, presence: true, format: ISO_CURRENCY_PATTERN

  validates :price_amount, presence: true, numericality: { greater_than: 0 }

  validates :tax_amount, presence: true, numericality: { greater_than: 0 }

  validates :tax_currency, presence: true, format: ISO_CURRENCY_PATTERN

  validates :stock, presence: true, numericality: { greater_than: 0 }

  def price
    Money.from_amount(price_amount.to_f, price_currency)
  end

  def tax
    Money.from_amount(tax_amount.to_f, tax_currency)
  end

  def as_json(*)
    attributes
  end
end
