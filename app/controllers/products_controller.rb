class ProductsController < ApplicationController
  # GET /products
  def index
    @products = Product.all
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_url,
                  notice: "Product was successfully created.",
                  status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  # PATCH/PUT /products/1
  def update
    @product = Product.find(params.expect(:id))
    if @product.update(product_params)
      redirect_to products_url, notice: "Product was successfully updated.",
                  status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product = Product.find(params.expect(:id))
    @product.destroy!
    redirect_to products_url, notice: "Product was successfully destroyed."
  end

  private

  # Only allow a list of trusted parameters through.
  def product_params
    params.expect(product: [ :name, :sku, :description, :price_amount, :price_currency, :tax_amount, :tax_currency, :stock ])
  end
end
