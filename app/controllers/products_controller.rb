class ProductsController < ApplicationController
  rescue_from Product::RecordNotFound, with: :record_not_found

  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/1
  def show
    @product = Product.find(params[:id])
    render json: @product
  end

  def record_not_found
    render json: { errors: [ "Record not found" ] }, status: :not_found
  end
end
