class AddColumnToOrderProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :order_products, :product_price, :float, null: true
  end
end
