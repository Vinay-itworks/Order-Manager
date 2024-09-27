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
    unless @orders
      flash[:alert] = "On product is mentioned."
    else
      @orders.each { |key, value|
        @product = Product.find(key)
        @order_price += @product.price * Integer(value)
        @products_ids << Array.new(Integer(value), @product.id)
      }
    end
    @hidden_params = { products_id: @products_ids, order_price: @order_price }
    # puts "Address options #{@address_options}"

    @order = Order.new()
  end

  # GET /orders/1/edit
  def edit
  end

  def empty_cart
    @cart = current_user.cart
    @cart.products = []
    @cart.save
  end

  # POST /orders or /orders.json
  def create
    @products_ids = order_params[:products_id].split(" ").map(&:to_i)
    puts "Products_ids:" + "#{@products_ids}"
    if @products_ids == []
      return redirect_to products_url, orders: @number, alert: "Add products to cart first or buy a product."
    end
    @order = Order.new(order_params.merge(user_id: current_user.id).except(:products_id, :actions))
    respond_to do |format|
      if @order.save
        @products_ids.each { |id|
          @@product = Product.find(id)
          @@product_order = @order.order_products.new()
          @@product_order.product_id = @@product.id
          @@product_order.product_price = @@product.current_price
          @@product_order.save
          puts @@product_order.errors.full_messages
        }
        if order_params[:actions]
          if order_params[:actions] == "cart"
            puts "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG "
            empty_cart
          end
        end
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
    @ord_pro = OrderProduct.find(@order.order_products.ids[0])
    @ord_pro.destroy!
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
      params.require(:order).permit(:user_id, :address_id, :products_id, :order_price, :actions)
    end
end
