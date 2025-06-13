# An item for sale in our online store.
#
# Saved in YAML for now, because we can't afford a DB
#
class Product
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Dirty

  extend YamlStorage
  extend QueryMethods


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


  def price_changed?
    price_amount_changed? || price_currency_changed?
  end

  def update(new_attributes)
    self.class.save(self, new_attributes.to_hash)
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
