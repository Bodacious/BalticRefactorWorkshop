require_relative 'config/boot'

require_relative 'app/models/product'
require_relative 'app/resources/products'

require_relative 'config/seed_data' unless Product.any? # populate the demo data
class ThirdPartyService < Sinatra::Base
  use Resources::Products

  get '/' do
    redirect "/products"
  end
end
