# An item for sale in our online store.
#
# Saved in YAML for now, because we can't afford a DB
#
class Product
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Dirty

  extend YAMLStorage

  ##
  # YAML Persistence. Matches ActiveRecord's API as much as possible
  class << self
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

    def save(product, changes = {})
      product.attributes = changes
      return false unless product.valid?

      # Set created_at if first save
      product.created_at ||= Time.now
      # Set updated at on every save
      product.updated_at = Time.now
      storage_key = storage_key_for_product(product)
      store_instance(read_only: false) do |store|
        store[storage_key] = safe_storage_attributes(product.attributes)
      end
    end

    def destroy!(product)
      storage_key = storage_key_for_product(product)
      store_instance(read_only: false) do |store|
        store.delete(storage_key)
      end
    end
  end

  attribute :id, :integer, default: nil

  attribute :sku, :string, default: ""

  attribute :name, :string, default: ""

  attribute :description, :string, default: ""

  attribute :price_amount, :decimal, precision: 10, scale: 2, default: 0.0

  DEFAULT_ISO_CURRENCY = "USD"
  attribute :price_currency, :string, default: DEFAULT_ISO_CURRENCY

  attribute :tax_amount, :decimal, precision: 10, scale: 2, default: 0.0
  attribute :tax_currency, :string, default: DEFAULT_ISO_CURRENCY

  attribute :stock, :integer, default: 0

  attribute :created_at, :datetime, default: Time.now

  attribute :updated_at, :datetime, default: Time.now

  validates :name, presence: true

  SKU_PATTERN = /\w{4}\-\w?\d{3}/i
  validates :sku, presence: true, format: SKU_PATTERN

  validates :description, presence: true

  validates :price_amount, presence: true, numericality: { greater_than: 0 }

  ISO_CURRENCY_PATTERN = /[A-Z]{3}/
  validates :price_currency, presence: true, format: ISO_CURRENCY_PATTERN

  validates :price_amount, presence: true, numericality: { greater_than: 0 }

  validates :tax_amount, presence: true, numericality: { greater_than: 0 }

  validates :tax_currency, presence: true, format: ISO_CURRENCY_PATTERN

  validates :stock, presence: true, numericality: { greater_than_or_equal: 0 }

  def inspect
    keyval_separator = "="
    attribute_separator = " "
    attributes.to_a.map { |(key, val)| [ key, val ].join(keyval_separator) }.join(attribute_separator)
  end

  def update(new_attributes)
    self.class.save(self, new_attributes.to_hash)
  end

  def price_changed?
    price_amount_changed? || price_currency_changed?
  end

  def save
    self.class.save(self, attributes)
  end

  # You tried to save a record that wasn't valid
  class Product::RecordInvalid < StandardError
  end
  def save!
    save || raise(RecordInvalid, "#{errors.to_a.to_sentence}")
  end

  def destroy!
    self.class.destroy!(self)
  end

  def persisted?
    id.present?
  end

  def valid?
    # Make sure we set the tax before running validations
    set_tax_from_price
    super
  end
  def price
    Money.from_amount(price_amount.to_f, price_currency)
  end

  def tax
    Money.from_amount(tax_amount.to_f, tax_currency)
  end

  def touch
    empty_changes = {}
    self.class.save(self, empty_changes)
  end

  def ratings
    Rating.for_product(self)
  end

  def cache_key
    "products/#{id.to_i}"
  end

  def average_rating
    Rails.cache.fetch([ cache_key, updated_at, "average_rating" ]) do
      ratings.average(:star_value)
    end
  end
  def as_json(*)
    attributes
  end

  private

  TAX_RATE = Rational(20, 100)  # 20 %
  def set_tax_from_price
    raise "Cannot set tax from price" unless price_amount.present? && price_currency.present?

    self.tax_amount = price_amount * TAX_RATE
    self.tax_currency = price_currency
  end
end
