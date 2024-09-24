class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      # t.references :products, null: false, foreign_key: true
      t.float :order_price

      t.timestamps
    end
  end
end
