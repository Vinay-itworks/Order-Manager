class CreateCarts < ActiveRecord::Migration[7.2]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true, index: true
      # t.references :product, null: true, foreign_key: true
      t.float :price

      t.timestamps
    end
  end
end
