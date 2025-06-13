class ProductsController < ApplicationController
  # GET /products
  def index
    @products = product_repository.all
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    if @product.valid?
      product_repository.create @product
      redirect_to products_url,
                  notice: "Product was successfully created.",
                  status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = product_repository.find(params[:id])
  end

  # PATCH/PUT /products/1
  def update
    @product = product_repository.find(params.expect(:id))
    if @product.update(product_params)
      redirect_to products_url, notice: "Product was successfully updated.",
                  status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product = product_repository.find(params.expect(:id))
    product_repository.destroy!(@product)
    redirect_to products_url, notice: "Product was successfully destroyed."
  end

  private

  def product_repository
    if true
      ProductRepositoryFactory.new(:yaml)
    else
      ProductRepositoryFactory.new(:json)
    end
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.expect(product: [ :name, :sku, :description, :price_amount, :price_currency, :tax_amount, :tax_currency, :stock ])
  end
end
