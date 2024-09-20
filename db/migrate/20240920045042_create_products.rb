class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.float :price
      t.float :compare_at_price
      t.float :discount
      t.boolean :is_active

      t.timestamps
    end
  end
end
