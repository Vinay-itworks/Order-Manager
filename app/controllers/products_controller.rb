class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :image_attached, only: [ :show ]

  # GET /products or /products.json
  def index
    @products = Product.page(params[:page]).per(3)
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_product_to_cart
    @product = Product.find(params["product_id"])
    @user_cart = current_user.cart.products
    @user_cart << @product
    redirect_to user_carts_url
  end

  def remove_product_to_cart
    @product = Product.find(params["product_id"])
    @cart = current_user.cart
    CartProduct.where("cart_id = ? AND product_id = ?", @cart.id, @product.id).first.delete
    redirect_to user_carts_url
  end

  def remove_all_from_cart
    @product = Product.find(params["product_id"])
    @cart = current_user.cart
    CartProduct.where("cart_id = ? AND product_id = ?", @cart.id, @product.id).delete_all
    redirect_to user_carts_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :discount, :is_active)
    end

    # check_image attached
    def image_attached
      if @product.photos == []
        flash[:notice] = "Add photos to your product for better reach."
      end
    end
end
