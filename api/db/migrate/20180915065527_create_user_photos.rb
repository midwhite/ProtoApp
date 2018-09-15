class CreateUserPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :user_photos do |t|
      t.references :user, null: false, index: true
      t.string :filename, null: false

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
