class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = current_user.orders
    # @products = @order.products.distinct
    # @number = @order.products.group(:id).count(:id)
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @addresses = current_user.addresses
    @address_options = []
    @addresses.each { |address|
      @address_options << [ address.values_at(:address_type, :address, :city).join(","), address.id ]
    }
    @orders = params[:orders]
    @order_price = 0
    @products_ids = []
    @orders.each { |key, value|
      @product = Product.find(key)
      @order_price += @product.price * Integer(value)
      @products_ids << Array.new(Integer(value), @product.id)
    }
    @hidden_params = { products_id: @products_ids, order_price: @order_price }
    # puts "Address options #{@address_options}"

    @order = Order.new()
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @products_ids = order_params[:products_id].split(" ").map(&:to_i)
    puts "Type:" + "#{order_params.class}"
    @order = Order.new(order_params.merge(user_id: current_user.id).except(:products_id))
    respond_to do |format|
      if @order.save
        @products_ids.each { |id|
          @@product = Product.find(id)
          @@product_order = @order.order_products.new()
          @@product_order.product_id = @@product
          @@product_order.product_price = @@product.current_price
          @@product_order.save
          # render :new, status: :unprocessable_entity unless @@product_order.save
        }
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, status: :see_other, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:user_id, :address_id, :products_id, :order_price)
    end
end
