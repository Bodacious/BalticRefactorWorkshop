# frozen_string_literal: true

module Resources
  class Products < Sinatra::Base
    register Sinatra::Namespace
    helpers Sinatra::JSON

    before do
      content_type :json
    end

    namespace '/products' do
      get '' do
        json Product.all
      end

      get '/:id' do
        product = Product.find_by(id: params[:id])
        halt 404, json({ error: 'Product not found' }) unless product
        json product
      end
    end
  end
end
