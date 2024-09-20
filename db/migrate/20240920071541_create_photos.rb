class CreatePhotos < ActiveRecord::Migration[7.2]
  def change
    create_table :photos do |t|
      t.references :photoable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
