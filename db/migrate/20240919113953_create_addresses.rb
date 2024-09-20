class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address_type
      t.text :address
      t.string :city
      t.string :state
      t.string :country
      t.integer :zipcode
      t.boolean :is_active

      t.timestamps
    end
  end
end
